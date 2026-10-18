<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.dao.CartDao"%>
<%@page import="com.eazydeals.entities.User"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page errorPage="error_exception.jsp"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
User activeUser = (User) session.getAttribute("activeUser");
if (activeUser == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("login.jsp");
	return;  
}

String from = request.getParameter("from");
if (from == null || from.trim().isEmpty()) {
	from = (String) session.getAttribute("from");
}
if (from == null) from = "cart";
session.setAttribute("from", from);

String pidParam = request.getParameter("pid");
if (pidParam != null && !pidParam.trim().isEmpty()) {
	try {
		session.setAttribute("pid", Integer.parseInt(pidParam.trim()));
	} catch (Exception e) {}
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Secure Checkout</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Header -->
		<div class="mb-4">
			<h3 class="fw-bold mb-1 d-flex align-items-center gap-2">
				<i class="fa-solid fa-lock text-primary"></i> Secure Order Checkout
			</h3>
			<p class="text-muted small mb-0">Confirm delivery destination and choose your preferred payment method</p>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<div class="row g-4">
			<!-- Left: Address & Payment Options -->
			<div class="col-lg-8">
				<!-- Step 1: Delivery Address Card -->
				<div class="card p-4 mb-4 shadow-sm border-0">
					<div class="d-flex justify-content-between align-items-center mb-3">
						<h5 class="fw-bold mb-0 text-dark d-flex align-items-center gap-2">
							<span class="badge bg-primary rounded-circle px-2 py-1 fs-6">1</span> Delivery Destination
						</h5>
						<button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#changeAddressModal">
							<i class="fa-solid fa-pen-to-square me-1"></i> Change Address
						</button>
					</div>

					<div class="p-3 bg-light rounded-3 border">
						<div class="fw-bold text-dark fs-6 mb-1">
							<%=activeUser.getUserName()%> &bull; <span class="text-muted fw-normal"><%=activeUser.getUserPhone()%></span>
						</div>
						<p class="text-secondary small mb-1">
							<%=activeUser.getUserAddress()%>, <%=activeUser.getUserCity()%>, <%=activeUser.getUserState()%> - <span class="fw-semibold text-dark"><%=activeUser.getUserPincode()%></span>
						</p>
						<span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1 small">
							<i class="fa-solid fa-location-dot me-1"></i> Default Shipping Address
						</span>
					</div>
				</div>

				<!-- Step 2: Payment Options Card -->
				<div class="card p-4 shadow-sm border-0">
					<h5 class="fw-bold mb-3 text-dark d-flex align-items-center gap-2">
						<span class="badge bg-primary rounded-circle px-2 py-1 fs-6">2</span> Select Payment Method
					</h5>

					<form id="checkoutOrderForm" action="OrderOperationServlet" method="post" onsubmit="return handlePlaceOrder(this, event)">
						<div class="row g-3 mb-4">
							<div class="col-md-6">
								<label class="card p-3 border h-100 cursor-pointer d-flex flex-row align-items-start gap-3 shadow-none">
									<input class="form-check-input mt-1" type="radio" name="payementMode" value="Card Payment" checked>
									<div>
										<div class="fw-bold text-dark mb-1">
											<i class="fa-regular fa-credit-card text-primary me-1"></i> Credit / Debit / ATM Card
										</div>
										<p class="text-muted small mb-0">Pay securely via Visa, Mastercard, RuPay, or Maestro</p>
									</div>
								</label>
							</div>

							<div class="col-md-6">
								<label class="card p-3 border h-100 cursor-pointer d-flex flex-row align-items-start gap-3 shadow-none">
									<input class="form-check-input mt-1" type="radio" name="payementMode" value="Cash on Delivery">
									<div>
										<div class="fw-bold text-dark mb-1">
											<i class="fa-solid fa-money-bill-wave text-success me-1"></i> Cash on Delivery (COD)
										</div>
										<p class="text-muted small mb-0">Pay in cash or UPI upon package doorstep arrival</p>
									</div>
								</label>
							</div>
						</div>

						<div class="d-flex justify-content-between align-items-center pt-3 border-top flex-wrap gap-2">
							<a href="cart.jsp" class="btn btn-outline-secondary">
								<i class="fa-solid fa-arrow-left me-1"></i> Return to Cart
							</a>
							<button type="submit" class="btn btn-primary btn-lg px-4 fw-bold">
								<i class="fa-solid fa-check-circle me-2"></i> Place Order Now
							</button>
						</div>
					</form>
				</div>
			</div>

			<!-- Right: Order Pricing Breakdown -->
			<div class="col-lg-4">
				<div class="card p-4 shadow-sm border-0 bg-white">
					<h5 class="fw-bold mb-3 border-bottom pb-2">Price Details</h5>
					<%
					float totalPrice = 0;
					int totalItems = 0;

					if ("cart".equals(from)) {
						CartDao cartDao = new CartDao(ConnectionProvider.getConnection());
						totalItems = cartDao.getCartCountByUserId(activeUser.getUserId());
						Object tpObj = session.getAttribute("totalPrice");
						if (tpObj != null) {
							totalPrice = (float) tpObj;
						} else {
							List<Cart> cl = cartDao.getCartListByUserId(activeUser.getUserId());
							ProductDao pdd = new ProductDao(ConnectionProvider.getConnection());
							for (Cart ci : cl) {
								Product prd = pdd.getProductsByProductId(ci.getProductId());
								if (prd != null) totalPrice += ci.getQuantity() * prd.getProductPriceAfterDiscount();
							}
						}
					} else {
						ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
						totalItems = 1;
						int pid = 0;
						if (session.getAttribute("pid") != null) {
							pid = (int) session.getAttribute("pid");
						}
						totalPrice = productDao.getProductPriceById(pid);
					}
					%>
					<div class="d-flex justify-content-between mb-2 text-muted small">
						<span>Items Count:</span>
						<span class="fw-semibold text-dark"><%=totalItems%> Item(s)</span>
					</div>
					<div class="d-flex justify-content-between mb-2 text-muted small">
						<span>Items Subtotal:</span>
						<span class="fw-semibold text-dark">&#8377;<%=totalPrice%></span>
					</div>
					<div class="d-flex justify-content-between mb-2 text-muted small">
						<span>Shipping Fee:</span>
						<span class="fw-semibold text-success">FREE</span>
					</div>
					<div class="d-flex justify-content-between mb-2 text-muted small">
						<span>Packaging Charges:</span>
						<span class="fw-semibold text-dark">&#8377;29</span>
					</div>
					<hr>
					<div class="d-flex justify-content-between align-items-center mb-4">
						<span class="fw-bold fs-6">Grand Total:</span>
						<span class="fw-bold fs-4 text-primary">&#8377;<%=totalPrice + 29%></span>
					</div>

					<div class="p-3 bg-light rounded-3 text-muted small">
						<i class="fa-solid fa-shield-halved text-success me-1"></i> <strong>Safe &amp; Protected</strong>
						<p class="mb-0 mt-1">Your order qualifies for EazyDeals Buyer Protection and Hassle-free Returns.</p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Modal: Change Shipping Address -->
	<div class="modal fade" id="changeAddressModal" tabindex="-1" aria-labelledby="changeAddressModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content rounded-4 border-0 shadow">
				<div class="modal-header bg-light border-0 py-3">
					<h5 class="modal-title fw-bold text-primary" id="changeAddressModalLabel">
						<i class="fa-solid fa-map-location-dot me-2"></i> Update Delivery Address
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<form id="addressForm" action="UpdateUserServlet" method="post" onsubmit="return validateAddressForm(this, event)">
					<input type="hidden" name="operation" value="changeAddress">
					<div class="modal-body p-4">
						<div class="mb-3">
							<label class="form-label" for="user_address">Street Address</label>
							<textarea id="user_address" name="user_address" rows="3" placeholder="Flat No., Building, Area and Street" class="form-control"><%=activeUser.getUserAddress()%></textarea>
							<div id="addressError" class="error-message">Street address is required!</div>
						</div>
						<div class="row g-3 mb-3">
							<div class="col-md-6">
								<label class="form-label" for="city">City / Town</label>
								<input id="city" class="form-control" type="text" name="city" placeholder="City" value="<%=activeUser.getUserCity()%>">
								<div id="cityError" class="error-message">City is required!</div>
							</div>
							<div class="col-md-6">
								<label class="form-label" for="pincode">Pincode</label>
								<input id="pincode" class="form-control" type="text" name="pincode" placeholder="6-digit pincode" maxlength="6" value="<%=activeUser.getUserPincode()%>">
								<div id="pincodeError" class="error-message">Valid 6-digit pincode is required!</div>
							</div>
						</div>
						<div class="mb-3">
							<label class="form-label" for="state">State</label>
							<select id="state" name="state" class="form-select">
								<option value="<%=activeUser.getUserState()%>" selected><%=activeUser.getUserState()%></option>
								<option value="Andhra Pradesh">Andhra Pradesh</option>
								<option value="Assam">Assam</option>
								<option value="Bihar">Bihar</option>
								<option value="Delhi">Delhi</option>
								<option value="Goa">Goa</option>
								<option value="Gujarat">Gujarat</option>
								<option value="Karnataka">Karnataka</option>
								<option value="Kerala">Kerala</option>
								<option value="Maharashtra">Maharashtra</option>
								<option value="Punjab">Punjab</option>
								<option value="Rajasthan">Rajasthan</option>
								<option value="Tamil Nadu">Tamil Nadu</option>
								<option value="Telangana">Telangana</option>
								<option value="Uttar Pradesh">Uttar Pradesh</option>
								<option value="West Bengal">West Bengal</option>
							</select>
							<div id="stateError" class="error-message">State is required!</div>
						</div>
					</div>
					<div class="modal-footer border-0 bg-light p-3">
						<button type="button" class="btn btn-secondary px-3" data-bs-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-primary px-4">Save Address</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
	function handlePlaceOrder(form, e) {
		e.preventDefault();
		const payMode = form.querySelector('input[name="payementMode"]:checked');
		const modeText = payMode ? payMode.value : "Selected Payment Method";

		confirmAction({
			title: 'Confirm Order Placement',
			text: 'Are you sure you want to place your order with ' + modeText + '?',
			icon: 'question',
			confirmText: 'Yes, Place Order',
			confirmColor: '#10b981'
		}, function () {
			form.submit();
		});
		return false;
	}

	function validateAddressForm(form, e) {
		let valid = true;
		const address = document.getElementById("user_address");
		const city = document.getElementById("city");
		const pincode = document.getElementById("pincode");
		const state = document.getElementById("state");

		[address, city, pincode, state].forEach(clearInputError);

		if (!address.value || address.value.trim() === "") {
			showInputError(address, "Street address is required!");
			valid = false;
		}

		if (!city.value || city.value.trim() === "") {
			showInputError(city, "City / Town is required!");
			valid = false;
		}

		const pinClean = pincode.value ? pincode.value.trim() : '';
		if (!pinClean || !/^\d{6}$/.test(pinClean)) {
			showInputError(pincode, "Valid 6-digit pincode is required!");
			valid = false;
		}

		if (!state.value || state.value === "") {
			showInputError(state, "Please select your state!");
			valid = false;
		}

		if (!valid) {
			e.preventDefault();
			return false;
		}

		return true;
	}
	</script>
</body>
</html>