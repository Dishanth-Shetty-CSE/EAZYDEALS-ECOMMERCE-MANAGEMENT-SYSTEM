<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.dao.CategoryDao"%>
<%@page import="com.eazydeals.dao.OrderDao"%>
<%@page import="com.eazydeals.dao.UserDao"%>
<%@page import="com.eazydeals.dao.AdminDao"%>
<%@page import="com.eazydeals.entities.Admin"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page errorPage="error_exception.jsp"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
Admin activeAdmin = (Admin) session.getAttribute("activeAdmin");
if (activeAdmin == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("adminlogin.jsp");
	return;
}

ProductDao pDao = new ProductDao(ConnectionProvider.getConnection());
CategoryDao cDao = new CategoryDao(ConnectionProvider.getConnection());
OrderDao oDao = new OrderDao(ConnectionProvider.getConnection());
UserDao uDao = new UserDao(ConnectionProvider.getConnection());
AdminDao aDao = new AdminDao(ConnectionProvider.getConnection());

int totalProducts = pDao.productCount();
int totalCategories = cDao.getAllCategories() != null ? cDao.getAllCategories().size() : 0;
int totalOrders = oDao.getAllOrder() != null ? oDao.getAllOrder().size() : 0;
int totalUsers = uDao.userCount();
int totalAdmins = aDao.getAllAdmin() != null ? aDao.getAllAdmin().size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Administrator Management Dashboard</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Admin Header Banner -->
		<div class="bg-white p-4 rounded-4 border mb-4 shadow-sm">
			<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
				<div>
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-1 small text-muted">
							<li class="breadcrumb-item"><a href="index.jsp" class="text-decoration-none">Storefront</a></li>
							<li class="breadcrumb-item active" aria-current="page">Admin Control Center</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Welcome back, <%=activeAdmin.getName()%></h3>
					<span class="text-muted small">Here is what is happening across the EazyDeals platform today</span>
				</div>
				<div class="d-flex gap-2">
					<button type="button" class="btn btn-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#add-product">
						<i class="fa-solid fa-plus me-1"></i> Add Product
					</button>
					<button type="button" class="btn btn-outline-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#add-category">
						<i class="fa-solid fa-folder-plus me-1"></i> Add Category
					</button>
				</div>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<!-- 1. Real Database Summary Metric Cards -->
		<div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-3 mb-4">
			<div class="col">
				<a href="display_products.jsp" class="admin-stat-card">
					<div class="admin-stat-icon bg-primary bg-opacity-10 text-primary">
						<i class="fa-solid fa-boxes-stacked"></i>
					</div>
					<div>
						<p class="admin-stat-title">Total Products</p>
						<h4 class="admin-stat-val"><%=totalProducts%></h4>
					</div>
				</a>
			</div>

			<div class="col">
				<a href="display_orders.jsp" class="admin-stat-card">
					<div class="admin-stat-icon bg-success bg-opacity-10 text-success">
						<i class="fa-solid fa-truck-ramp-box"></i>
					</div>
					<div>
						<p class="admin-stat-title">Customer Orders</p>
						<h4 class="admin-stat-val"><%=totalOrders%></h4>
					</div>
				</a>
			</div>

			<div class="col">
				<a href="display_category.jsp" class="admin-stat-card">
					<div class="admin-stat-icon bg-warning bg-opacity-10 text-warning">
						<i class="fa-solid fa-layer-group"></i>
					</div>
					<div>
						<p class="admin-stat-title">Categories</p>
						<h4 class="admin-stat-val"><%=totalCategories%></h4>
					</div>
				</a>
			</div>

			<div class="col">
				<a href="display_users.jsp" class="admin-stat-card">
					<div class="admin-stat-icon bg-info bg-opacity-10 text-info">
						<i class="fa-solid fa-users"></i>
					</div>
					<div>
						<p class="admin-stat-title">Registered Users</p>
						<h4 class="admin-stat-val"><%=totalUsers%></h4>
					</div>
				</a>
			</div>
		</div>

		<!-- 2. Administrative Management Modules -->
		<h5 class="fw-bold text-dark mb-3">Administrative Management Modules</h5>
		<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-4">
			<!-- Product Management -->
			<div class="col">
				<div class="card h-100 p-4 shadow-sm border-0">
					<div class="d-flex align-items-center gap-3 mb-3">
						<div class="p-3 bg-primary bg-opacity-10 text-primary rounded-3 fs-3">
							<i class="fa-solid fa-box-open"></i>
						</div>
						<div>
							<h5 class="fw-bold text-dark mb-0">Products Catalog</h5>
							<span class="text-muted small"><%=totalProducts%> Items in inventory</span>
						</div>
					</div>
					<p class="text-secondary small mb-4">Update product pricing, stock availability, discounts, specs, and upload catalog images.</p>
					<div class="d-flex gap-2 mt-auto">
						<a href="display_products.jsp" class="btn btn-sm btn-primary flex-grow-1">
							<i class="fa-solid fa-list me-1"></i> View All Products
						</a>
						<button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#add-product">
							<i class="fa-solid fa-plus"></i>
						</button>
					</div>
				</div>
			</div>

			<!-- Category Management -->
			<div class="col">
				<div class="card h-100 p-4 shadow-sm border-0">
					<div class="d-flex align-items-center gap-3 mb-3">
						<div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 fs-3">
							<i class="fa-solid fa-tags"></i>
						</div>
						<div>
							<h5 class="fw-bold text-dark mb-0">Categories</h5>
							<span class="text-muted small"><%=totalCategories%> Configured categories</span>
						</div>
					</div>
					<p class="text-secondary small mb-4">Create, edit, organize storefront classification, and maintain category showcase imagery.</p>
					<div class="d-flex gap-2 mt-auto">
						<a href="display_category.jsp" class="btn btn-sm btn-warning text-dark fw-semibold flex-grow-1">
							<i class="fa-solid fa-layer-group me-1"></i> View Categories
						</a>
						<button type="button" class="btn btn-sm btn-outline-warning text-dark" data-bs-toggle="modal" data-bs-target="#add-category">
							<i class="fa-solid fa-plus"></i>
						</button>
					</div>
				</div>
			</div>

			<!-- Order Management -->
			<div class="col">
				<div class="card h-100 p-4 shadow-sm border-0">
					<div class="d-flex align-items-center gap-3 mb-3">
						<div class="p-3 bg-success bg-opacity-10 text-success rounded-3 fs-3">
							<i class="fa-solid fa-truck-fast"></i>
						</div>
						<div>
							<h5 class="fw-bold text-dark mb-0">Customer Orders</h5>
							<span class="text-muted small"><%=totalOrders%> Total orders recorded</span>
						</div>
					</div>
					<p class="text-secondary small mb-4">Track shipments, confirm pending orders, process dispatch status, and manage deliveries.</p>
					<div class="d-flex gap-2 mt-auto">
						<a href="display_orders.jsp" class="btn btn-sm btn-success flex-grow-1">
							<i class="fa-solid fa-clipboard-check me-1"></i> Manage Orders
						</a>
					</div>
				</div>
			</div>

			<!-- User Management -->
			<div class="col">
				<div class="card h-100 p-4 shadow-sm border-0">
					<div class="d-flex align-items-center gap-3 mb-3">
						<div class="p-3 bg-info bg-opacity-10 text-info rounded-3 fs-3">
							<i class="fa-solid fa-users-gear"></i>
						</div>
						<div>
							<h5 class="fw-bold text-dark mb-0">Registered Customers</h5>
							<span class="text-muted small"><%=totalUsers%> Active customer accounts</span>
						</div>
					</div>
					<p class="text-secondary small mb-4">Inspect customer profiles, registered email addresses, phone contacts, and delivery locations.</p>
					<div class="d-flex gap-2 mt-auto">
						<a href="display_users.jsp" class="btn btn-sm btn-info text-dark fw-semibold flex-grow-1">
							<i class="fa-solid fa-user-group me-1"></i> View Customers
						</a>
					</div>
				</div>
			</div>

			<!-- Administrator Team -->
			<div class="col">
				<div class="card h-100 p-4 shadow-sm border-0">
					<div class="d-flex align-items-center gap-3 mb-3">
						<div class="p-3 bg-secondary bg-opacity-10 text-secondary rounded-3 fs-3">
							<i class="fa-solid fa-user-shield"></i>
						</div>
						<div>
							<h5 class="fw-bold text-dark mb-0">Administrator Team</h5>
							<span class="text-muted small"><%=totalAdmins%> Team members</span>
						</div>
					</div>
					<p class="text-secondary small mb-4">Add new administrators, review operational team members, and manage dashboard access.</p>
					<div class="d-flex gap-2 mt-auto">
						<a href="display_admin.jsp" class="btn btn-sm btn-secondary flex-grow-1">
							<i class="fa-solid fa-user-plus me-1"></i> Add / View Admins
						</a>
					</div>
				</div>
			</div>

			<!-- Storefront Preview -->
			<div class="col">
				<div class="card h-100 p-4 shadow-sm border-0 bg-primary text-white">
					<div class="d-flex align-items-center gap-3 mb-3">
						<div class="p-3 bg-white text-primary rounded-3 fs-3 shadow-sm d-flex align-items-center justify-content-center" style="width: 58px; height: 58px;">
							<i class="fa-solid fa-store"></i>
						</div>
						<div>
							<h5 class="fw-bold text-white mb-0">Live Customer Store</h5>
							<span class="text-white-50 small">Production Storefront</span>
						</div>
					</div>
					<p class="text-white-50 small mb-4">Preview customer shopping flow, live discounts, categories, and test user cart experience.</p>
					<div class="d-flex gap-2 mt-auto">
						<a href="index.jsp" class="btn btn-sm btn-light fw-bold flex-grow-1">
							<i class="fa-solid fa-arrow-up-right-from-square me-1"></i> Browse Storefront
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 text-muted small">
				<div>
					<span class="fw-bold text-white">EazyDeals Management System</span> &bull; Logged in as: <%=activeAdmin.getEmail()%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>
