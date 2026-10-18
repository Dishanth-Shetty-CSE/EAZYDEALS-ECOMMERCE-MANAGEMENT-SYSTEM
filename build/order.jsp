<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.entities.OrderedProduct"%>
<%@page import="com.eazydeals.entities.Order"%>
<%@page import="java.util.List"%>
<%@page import="com.eazydeals.dao.OrderedProductDao"%>
<%@page import="com.eazydeals.dao.OrderDao"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page import="com.eazydeals.entities.User"%>
<%@page errorPage="error_exception.jsp"%>

<%
User u2 = (User) session.getAttribute("activeUser");
if (u2 == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("login.jsp");
	return;
}
OrderDao orderDao = new OrderDao(ConnectionProvider.getConnection());
OrderedProductDao ordProdDao = new OrderedProductDao(ConnectionProvider.getConnection());

List<Order> orderList = orderDao.getAllOrderByUserId(u2.getUserId());
%>
<div class="p-4">
	<h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
		<i class="fa-solid fa-box-open text-primary"></i> Order History &amp; Tracking
	</h4>
	<p class="text-muted small mb-4">View your past orders, delivery tracking status, and invoice summaries</p>

	<%
	if (orderList == null || orderList.isEmpty()) {
	%>
	<div class="p-5 text-center bg-light rounded-4 border">
		<img src="Images/empty-cart-icon.png" alt="No Orders Found" class="img-fluid mb-3" style="max-width: 140px;">
		<h5 class="fw-bold text-dark mt-2">No Past Orders Found</h5>
		<p class="text-muted small mx-auto" style="max-width: 380px;">You haven't placed any orders yet. Discover our latest collections and start shopping today!</p>
		<a href="products?category=0" class="btn btn-primary btn-sm px-3 mt-2">Explore Catalog</a>
	</div>
	<%
	} else {
	%>
	<div class="table-responsive shadow-sm">
		<table class="table align-middle">
			<thead>
				<tr>
					<th style="width: 70px;">Item</th>
					<th>Order Details</th>
					<th class="text-center">Qty</th>
					<th class="text-center">Amount</th>
					<th>Ordered Date</th>
					<th>Payment</th>
					<th class="text-center">Status</th>
				</tr>
			</thead>
			<tbody>
				<%
				for (Order ord : orderList) {
					List<OrderedProduct> ordProdList = ordProdDao.getAllOrderedProduct(ord.getId());
					if (ordProdList == null) continue;
					for (OrderedProduct op : ordProdList) {
				%>
				<tr>
					<td>
						<div class="p-1 bg-light rounded-3 text-center border">
							<img src="Product_imgs/<%=op.getImage()%>" alt="<%=op.getName()%>" style="height: 48px; width: 48px; object-fit: contain;" onerror="this.src='Images/product.png'">
						</div>
					</td>
					<td>
						<div class="fw-bold text-dark text-truncate" style="max-width: 220px;"><%=op.getName()%></div>
						<span class="text-muted small">Order #<%=ord.getOrderId()%></span>
					</td>
					<td class="text-center fw-semibold"><%=op.getQuantity()%></td>
					<td class="text-center fw-bold text-primary">&#8377;<%=op.getPrice() * op.getQuantity()%></td>
					<td class="small text-secondary"><%=ord.getDate()%></td>
					<td>
						<span class="badge bg-light text-dark border"><%=ord.getPayementType()%></span>
					</td>
					<td class="text-center">
						<%
						String stClass = "placed";
						String stIcon = "fa-clock";
						if ("Order Confirmed".equalsIgnoreCase(ord.getStatus())) {
							stClass = "confirmed";
							stIcon = "fa-check";
						} else if ("Out For Delivery".equalsIgnoreCase(ord.getStatus())) {
							stClass = "out-delivery";
							stIcon = "fa-truck-fast";
						} else if ("Delivered".equalsIgnoreCase(ord.getStatus())) {
							stClass = "delivered";
							stIcon = "fa-circle-check";
						}
						%>
						<span class="status-badge <%=stClass%>">
							<i class="fa-solid <%=stIcon%>"></i> <%=ord.getStatus()%>
						</span>
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
