<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.dao.UserDao"%>
<%@page errorPage="error_exception.jsp"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.eazydeals.entities.OrderedProduct"%>
<%@page import="com.eazydeals.entities.Order"%>
<%@page import="java.util.List"%>
<%@page import="com.eazydeals.dao.OrderedProductDao"%>
<%@page import="com.eazydeals.dao.OrderDao"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>

<%
Admin activeAdmin = (Admin) session.getAttribute("activeAdmin");
if (activeAdmin == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("adminlogin.jsp");
	return;
}
OrderDao orderDao = new OrderDao(ConnectionProvider.getConnection());
OrderedProductDao ordProdDao = new OrderedProductDao(ConnectionProvider.getConnection());
List<Order> orderList = orderDao.getAllOrder();
UserDao userDao = new UserDao(ConnectionProvider.getConnection());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Manage Orders &amp; Shipments</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Header -->
		<div class="bg-white p-4 rounded-4 border mb-4 shadow-sm">
			<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
				<div>
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-1 small text-muted">
							<li class="breadcrumb-item"><a href="admin.jsp" class="text-decoration-none">Dashboard</a></li>
							<li class="breadcrumb-item active" aria-current="page">Order Management</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Customer Orders (<%=orderList != null ? orderList.size() : 0%>)</h3>
					<span class="text-muted small">Update shipping status, inspect customer destinations, and verify transactions</span>
				</div>
				<a href="admin.jsp" class="btn btn-outline-secondary btn-sm px-3">
					<i class="fa-solid fa-arrow-left me-1"></i> Dashboard
				</a>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<%
		if (orderList == null || orderList.isEmpty()) {
		%>
		<div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
			<img src="Images/empty-cart-icon.png" alt="No Orders" class="img-fluid mb-3" style="max-width: 140px;">
			<h4 class="fw-bold text-dark mt-2">Zero Orders Recorded</h4>
			<p class="text-muted small mx-auto" style="max-width: 420px;">No customer orders have been placed yet. New orders will automatically appear here in real-time.</p>
		</div>
		<%
		} else {
		%>
		<div class="table-responsive shadow-sm">
			<table class="table align-middle">
				<thead>
					<tr>
						<th style="width: 70px;">Item</th>
						<th style="width: 160px;">Order ID</th>
						<th>Ordered Products</th>
						<th>Shipping Destination</th>
						<th>Ordered On</th>
						<th>Payment</th>
						<th class="text-center">Status</th>
						<th style="width: 220px;">Update Tracking</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (Order order : orderList) {
						List<OrderedProduct> ordProdList = ordProdDao.getAllOrderedProduct(order.getId());
						if (ordProdList == null) continue;
						for (OrderedProduct orderProduct : ordProdList) {
					%>
					<tr>
						<td>
							<div class="p-1 bg-light rounded-3 text-center border">
								<img src="Product_imgs/<%=orderProduct.getImage()%>" alt="<%=orderProduct.getName()%>" style="height: 48px; width: 48px; object-fit: contain;">
							</div>
						</td>
						<td>
							<span class="fw-bold text-dark font-monospace">#<%=order.getOrderId()%></span>
						</td>
						<td>
							<div class="fw-bold text-dark text-truncate" style="max-width: 200px;"><%=orderProduct.getName()%></div>
							<span class="text-muted small">Qty: <%=orderProduct.getQuantity()%> &bull; Total: <strong class="text-dark">&#8377;<%=orderProduct.getPrice() * orderProduct.getQuantity()%></strong></span>
						</td>
						<td>
							<div class="fw-semibold text-dark"><%=userDao.getUserName(order.getUserId())%></div>
							<div class="text-muted small"><i class="fa-solid fa-phone me-1"></i> <%=userDao.getUserPhone(order.getUserId())%></div>
							<div class="text-muted small text-truncate" style="max-width: 220px;"><%=userDao.getUserAddress(order.getUserId())%></div>
						</td>
						<td class="small text-secondary"><%=order.getDate()%></td>
						<td>
							<span class="badge bg-light text-dark border"><%=order.getPayementType()%></span>
						</td>
						<td class="text-center">
							<%
							String stClass = "placed";
							String stIcon = "fa-clock";
							if ("Order Confirmed".equalsIgnoreCase(order.getStatus())) {
								stClass = "confirmed";
								stIcon = "fa-check";
							} else if ("Out For Delivery".equalsIgnoreCase(order.getStatus())) {
								stClass = "out-delivery";
								stIcon = "fa-truck-fast";
							} else if ("Delivered".equalsIgnoreCase(order.getStatus())) {
								stClass = "delivered";
								stIcon = "fa-circle-check";
							}
							%>
							<span class="status-badge <%=stClass%>">
								<i class="fa-solid <%=stIcon%>"></i> <%=order.getStatus()%>
							</span>
						</td>
						<td>
							<form action="UpdateOrderServlet?oid=<%=order.getId()%>" method="post" class="d-flex gap-1" onsubmit="return handleUpdateOrderStatus(this, event)">
								<select name="status" class="form-select form-select-sm" style="min-width: 130px;">
									<option value="" disabled selected>Select Action</option>
									<option value="Order Confirmed" <%= "Order Confirmed".equalsIgnoreCase(order.getStatus()) ? "disabled" : "" %>>Confirm Order</option>
									<option value="Out For Delivery" <%= "Out For Delivery".equalsIgnoreCase(order.getStatus()) ? "disabled" : "" %>>Out for Delivery</option>
									<option value="Delivered" <%= "Delivered".equalsIgnoreCase(order.getStatus()) ? "disabled" : "" %>>Mark Delivered</option>
								</select>
								<button type="submit" class="btn btn-sm btn-primary px-2" <%= "Delivered".equalsIgnoreCase(order.getStatus()) ? "disabled" : "" %> title="Save status">
									<i class="fa-solid fa-check"></i>
								</button>
							</form>
						</td>
					</tr>
					<%
						}
					}
					%>
				</tbody>
			</table>
		</div>
		<%
		}
		%>
	</div>

	<script>
	function handleUpdateOrderStatus(form, e) {
		const sel = form.querySelector('select[name="status"]');
		if (!sel.value || sel.value === "") {
			e.preventDefault();
			showInputError(sel, "Select a valid status!");
			return false;
		}
		clearInputError(sel);

		e.preventDefault();
		confirmAction({
			title: 'Update Order Status',
			text: 'Are you sure you want to change order status to: "' + sel.value + '"?',
			icon: 'question',
			confirmText: 'Yes, Update Status'
		}, function () {
			form.submit();
		});
		return false;
	}
	</script>

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 text-muted small">
				<div>
					<span class="fw-bold text-white">EazyDeals Order Management</span> &bull; Logged in as: <%=activeAdmin.getEmail()%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>
