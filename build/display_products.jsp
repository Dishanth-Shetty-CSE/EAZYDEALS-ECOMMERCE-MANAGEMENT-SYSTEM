<%@page import="com.eazydeals.entities.Message"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page errorPage="error_exception.jsp"%>
<%@page import="com.eazydeals.dao.UserDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.dao.CategoryDao"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page import="java.util.List"%>

<%
Admin activeAdmin = (Admin) session.getAttribute("activeAdmin");
if (activeAdmin == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("adminlogin.jsp");
	return;
}
ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
CategoryDao categoryDao = new CategoryDao(ConnectionProvider.getConnection());
List<Product> productList = productDao.getAllProducts();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Manage Products</title>
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
							<li class="breadcrumb-item active" aria-current="page">Products Inventory</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Products Inventory (<%=productList != null ? productList.size() : 0%>)</h3>
					<span class="text-muted small">Manage catalog pricing, stock inventory, and discounts</span>
				</div>
				<div class="d-flex gap-2">
					<button type="button" class="btn btn-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#add-product">
						<i class="fa-solid fa-plus me-1"></i> Add New Product
					</button>
					<a href="admin.jsp" class="btn btn-outline-secondary btn-sm px-3">
						<i class="fa-solid fa-arrow-left me-1"></i> Dashboard
					</a>
				</div>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<%
		if (productList == null || productList.isEmpty()) {
		%>
		<div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
			<img src="Images/no-results.png" alt="No Products" class="img-fluid mb-3" style="max-width: 140px;">
			<h4 class="fw-bold text-dark mt-2">Zero Products in Inventory</h4>
			<p class="text-muted small mx-auto" style="max-width: 420px;">Your product catalog is currently empty. Use the "Add New Product" button above to publish your first item.</p>
			<button type="button" class="btn btn-primary px-4 mt-2" data-bs-toggle="modal" data-bs-target="#add-product">
				Add First Product
			</button>
		</div>
		<%
		} else {
		%>
		<div class="table-responsive shadow-sm">
			<table class="table align-middle">
				<thead>
					<tr>
						<th style="width: 70px;">Image</th>
						<th>Product Name</th>
						<th>Category</th>
						<th class="text-center">Selling Price</th>
						<th class="text-center">Stock</th>
						<th class="text-center">Discount</th>
						<th class="text-center" style="width: 160px;">Actions</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (Product prod : productList) {
						String category = categoryDao.getCategoryName(prod.getCategoryId());
					%>
					<tr>
						<td>
							<div class="p-1 bg-light rounded-3 text-center border">
								<img src="Product_imgs/<%=prod.getProductImages()%>" alt="<%=prod.getProductName()%>" style="height: 50px; width: 50px; object-fit: contain;" onerror="this.src='Images/product.png'">
							</div>
						</td>
						<td>
							<div class="fw-bold text-dark text-truncate" style="max-width: 280px;"><%=prod.getProductName()%></div>
							<span class="text-muted small">Original: &#8377;<%=prod.getProductPrice()%></span>
						</td>
						<td>
							<span class="badge bg-light text-dark border"><%=category%></span>
						</td>
						<td class="text-center fw-bold text-primary">
							&#8377;<%=prod.getProductPriceAfterDiscount()%>
						</td>
						<td class="text-center">
							<% if (prod.getProductQunatity() > 10) { %>
							<span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1"><%=prod.getProductQunatity()%> in stock</span>
							<% } else if (prod.getProductQunatity() > 0) { %>
							<span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 px-2 py-1">Low: <%=prod.getProductQunatity()%> left</span>
							<% } else { %>
							<span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-2 py-1">Out of stock</span>
							<% } %>
						</td>
						<td class="text-center">
							<% if (prod.getProductDiscount() > 0) { %>
							<span class="badge bg-success text-white"><%=prod.getProductDiscount()%>% OFF</span>
							<% } else { %>
							<span class="text-muted small">-</span>
							<% } %>
						</td>
						<td class="text-center">
							<a href="update_product.jsp?pid=<%=prod.getProductId()%>" class="btn btn-sm btn-outline-primary me-1" title="Edit product details">
								<i class="fa-solid fa-pen-to-square"></i>
							</a>
							<button type="button" class="btn btn-sm btn-outline-danger" data-pid="<%=prod.getProductId()%>" onclick="confirmDeleteProduct(this.dataset.pid, event)" title="Delete product">
								<i class="fa-regular fa-trash-can"></i>
							</button>
						</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<%
		}
		%>
	</div>

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 text-muted small">
				<div>
					<span class="fw-bold text-white">EazyDeals Product Management</span> &bull; Logged in as: <%=activeAdmin.getEmail()%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>
