<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.entities.Cart"%>
<%@page import="com.eazydeals.dao.CartDao"%>
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

CartDao cartDao = new CartDao(ConnectionProvider.getConnection());
List<Cart> listOfCart = cartDao.getCartListByUserId(activeUser.getUserId());
ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());

float totalPrice = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Shopping Cart</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Header -->
		<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
			<div>
				<h3 class="fw-bold mb-1 d-flex align-items-center gap-2">
					<i class="fa-solid fa-cart-shopping text-primary"></i> Shopping Cart
				</h3>
				<p class="text-muted small mb-0">Review items in your bag before proceeding to checkout</p>
			</div>
			<a href="products?category=0" class="btn btn-outline-secondary btn-sm">
				<i class="fa-solid fa-arrow-left me-1"></i> Continue Shopping
			</a>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<%
		if (listOfCart == null || listOfCart.isEmpty()) {
		%>
		<!-- Empty Cart State -->
		<div class="bg-white p-5 rounded-4 border text-center shadow-sm my-4">
			<img src="Images/empty-cart-icon.png" alt="Empty Shopping Bag" class="img-fluid mb-3" style="max-width: 180px;">
			<h4 class="fw-bold text-dark mt-2">Your Shopping Cart is Empty</h4>
			<p class="text-muted mx-auto" style="max-width: 480px;">Explore our catalog to discover incredible discounts on electronics, laptops, mobiles, and home appliances!</p>
			<div class="mt-4">
				<a href="products?category=0" class="btn btn-primary px-4 py-2 fw-semibold">
					<i class="fa-solid fa-bag-shopping me-2"></i> Start Shopping Now
				</a>
			</div>
		</div>
		<%
		} else {
		%>
		<div class="row g-4">
			<!-- Cart Items Table -->
			<div class="col-lg-8">
				<div class="table-responsive shadow-sm">
					<table class="table align-middle">
						<thead>
							<tr>
								<th style="width: 80px;">Product</th>
								<th>Details</th>
								<th class="text-center">Price</th>
								<th class="text-center" style="width: 140px;">Quantity</th>
								<th class="text-center">Total</th>
								<th class="text-center" style="width: 80px;">Action</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (Cart c : listOfCart) {
								Product prod = productDao.getProductsByProductId(c.getProductId());
								if (prod == null) continue;
								float itemTotal = c.getQuantity() * prod.getProductPriceAfterDiscount();
								totalPrice += itemTotal;
							%>
							<tr>
								<td>
									<div class="p-1 bg-light rounded-3 text-center border">
										<img src="Product_imgs/<%=prod.getProductImages()%>" alt="<%=prod.getProductName()%>" style="height: 55px; width: 55px; object-fit: contain;" onerror="this.src='Images/product.png'">
									</div>
								</td>
								<td>
									<a href="viewProduct.jsp?pid=<%=prod.getProductId()%>" class="text-decoration-none text-dark fw-semibold d-block text-truncate" style="max-width: 260px;">
										<%=prod.getProductName()%>
									</a>
									<span class="text-muted small">&#8377;<%=prod.getProductPriceAfterDiscount()%> each</span>
								</td>
								<td class="text-center fw-semibold">
									&#8377;<%=prod.getProductPriceAfterDiscount()%>
								</td>
								<td class="text-center">
									<div class="qty-box">
										<a href="CartOperationServlet?cid=<%=c.getCartId()%>&opt=2" class="qty-btn <%=c.getQuantity() <= 1 ? "disabled opacity-50" : ""%>" aria-label="Decrease quantity">
											<i class="fa-solid fa-minus"></i>
										</a>
										<input type="text" class="qty-input" value="<%=c.getQuantity()%>" readonly>
										<a href="CartOperationServlet?cid=<%=c.getCartId()%>&opt=1" class="qty-btn" aria-label="Increase quantity">
											<i class="fa-solid fa-plus"></i>
										</a>
									</div>
								</td>
								<td class="text-center fw-bold text-primary">
									&#8377;<%=itemTotal%>
								</td>
								<td class="text-center">
									<button type="button" class="btn btn-sm btn-outline-danger border-0 p-2" data-cid="<%=c.getCartId()%>" onclick="confirmCartRemoval(this.dataset.cid, event)" title="Remove item">
										<i class="fa-regular fa-trash-can fs-6"></i>
									</button>
								</td>
							</tr>
							<%
							}
							session.setAttribute("totalPrice", totalPrice);
							session.setAttribute("from", "cart");
							%>
						</tbody>
					</table>
				</div>
			</div>

			<!-- Order Summary Sidebar -->
			<div class="col-lg-4">
				<div class="card p-4 shadow-sm border-0 bg-white">
					<h5 class="fw-bold mb-3 border-bottom pb-2">Order Summary</h5>
					<div class="d-flex justify-content-between mb-2 text-muted small">
						<span>Items Subtotal (<%=listOfCart.size()%> items):</span>
						<span class="fw-semibold text-dark">&#8377;<%=totalPrice%></span>
					</div>
					<div class="d-flex justify-content-between mb-2 text-muted small">
						<span>Standard Delivery:</span>
						<span class="fw-semibold text-success">FREE</span>
					</div>
					<div class="d-flex justify-content-between mb-2 text-muted small">
						<span>Packaging &amp; Handling:</span>
						<span class="fw-semibold text-dark">&#8377;29</span>
					</div>
					<hr>
					<div class="d-flex justify-content-between align-items-center mb-4">
						<span class="fw-bold fs-6">Total Amount Payable:</span>
						<span class="fw-bold fs-4 text-primary">&#8377;<%=totalPrice + 29%></span>
					</div>
					<div class="d-grid gap-2">
						<a href="checkout.jsp?from=cart" class="btn btn-primary py-3 fw-bold">
							<i class="fa-solid fa-lock me-2"></i> Proceed to Checkout
						</a>
						<a href="products?category=0" class="btn btn-outline-secondary py-2">
							Add More Products
						</a>
					</div>

					<div class="mt-4 pt-3 border-top text-center text-muted small">
						<i class="fa-solid fa-shield-halved text-success me-1"></i> Safe &amp; Secure 256-bit Encrypted Checkout
					</div>
				</div>
			</div>
		</div>
		<%
		}
		%>
	</div>

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<div class="row g-4">
				<div class="col-lg-4 col-md-6">
					<div class="footer-brand mb-3">
						<span class="brand-badge fs-4 p-2 me-2"><i class="fa-solid fa-bag-shopping"></i></span>
						<span class="fw-bold fs-4 text-white">Eazy<span class="highlight">Deals</span></span>
					</div>
					<p class="pe-lg-4">Explore thousands of verified products across laptops, mobiles, fashion, home essentials, and entertainment with best market discounts.</p>
					<div class="footer-socials mt-3">
						<a href="https://facebook.com" target="_blank" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
						<a href="https://twitter.com" target="_blank" aria-label="Twitter"><i class="fa-brands fa-twitter"></i></a>
						<a href="https://instagram.com" target="_blank" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
						<a href="https://linkedin.com" target="_blank" aria-label="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
					</div>
				</div>

				<div class="col-lg-2 col-md-6 col-6">
					<h5>Categories</h5>
					<ul class="footer-links">
						<%
						if (categoryList != null) {
							int cCount = 0;
							for (Category c : categoryList) {
								if (cCount++ >= 5) break;
						%>
						<li><a href="products?category=<%=c.getCategoryId()%>"><%=c.getCategoryName()%></a></li>
						<%
							}
						}
						%>
						<li><a href="products?category=0">All Categories</a></li>
					</ul>
				</div>

				<div class="col-lg-2 col-md-6 col-6">
					<h5>Customer Care</h5>
					<ul class="footer-links">
						<li><a href="profile.jsp">My Account</a></li>
						<li><a href="cart.jsp">Shopping Cart</a></li>
						<li><a href="login.jsp">Customer Sign In</a></li>
						<li><a href="adminlogin.jsp">Admin Portal</a></li>
					</ul>
				</div>

				<div class="col-lg-4 col-md-6">
					<h5>Newsletter</h5>
					<p>Subscribe to receive promotional coupons and special sale announcements.</p>
					<form class="d-flex gap-2 mt-3" onsubmit="event.preventDefault(); Swal.fire('Subscribed!', 'Thank you for subscribing to EazyDeals updates.', 'success');">
						<input type="email" class="form-control" placeholder="Enter your email" required style="border-radius: 8px;">
						<button type="submit" class="btn btn-primary px-3 text-nowrap">Join</button>
					</form>
				</div>
			</div>

			<div class="footer-bottom">
				<p class="mb-0">&copy; <%= java.time.Year.now().getValue() %> EazyDeals E-Commerce Management System. All rights reserved.</p>
			</div>
		</div>
	</footer>

</body>
</html>
