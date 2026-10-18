<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.entities.Category"%>
<%@page import="com.eazydeals.dao.CategoryDao"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page import="java.util.List"%>
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
CategoryDao cDao = new CategoryDao(ConnectionProvider.getConnection());
List<Category> catList = cDao.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Manage Categories</title>
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
							<li class="breadcrumb-item active" aria-current="page">Categories</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Category Management (<%=catList != null ? catList.size() : 0%>)</h3>
					<span class="text-muted small">Organize store classification and showcase imagery</span>
				</div>
				<div class="d-flex gap-2">
					<button type="button" class="btn btn-warning text-dark fw-semibold btn-sm px-3" data-bs-toggle="modal" data-bs-target="#add-category">
						<i class="fa-solid fa-plus me-1"></i> Add New Category
					</button>
					<a href="admin.jsp" class="btn btn-outline-secondary btn-sm px-3">
						<i class="fa-solid fa-arrow-left me-1"></i> Dashboard
					</a>
				</div>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<%
		if (catList == null || catList.isEmpty()) {
		%>
		<div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
			<img src="Images/no-results.png" alt="No Categories" class="img-fluid mb-3" style="max-width: 140px;">
			<h4 class="fw-bold text-dark mt-2">No Categories Configured</h4>
			<p class="text-muted small mx-auto" style="max-width: 420px;">There are no product categories setup yet. Click below to add your first category.</p>
			<button type="button" class="btn btn-warning px-4 mt-2" data-bs-toggle="modal" data-bs-target="#add-category">
				Create Category
			</button>
		</div>
		<%
		} else {
		%>
		<div class="table-responsive shadow-sm">
			<table class="table align-middle">
				<thead>
					<tr>
						<th style="width: 80px;">Icon / Image</th>
						<th>Category Name</th>
						<th class="text-center" style="width: 120px;">Category ID</th>
						<th class="text-center" style="width: 160px;">Actions</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (Category c : catList) {
					%>
					<tr>
						<td>
							<div class="p-1 bg-light rounded-3 text-center border d-inline-block">
								<img src="Product_imgs/<%=c.getCategoryImage()%>" alt="<%=c.getCategoryName()%>" style="height: 50px; width: 50px; object-fit: contain;">
							</div>
						</td>
						<td>
							<a href="display_products.jsp?category=<%=c.getCategoryId()%>" class="fw-bold text-dark fs-6 text-decoration-none" title="Filter products by <%=c.getCategoryName()%>">
								<%=c.getCategoryName()%> <i class="fa-solid fa-arrow-up-right-from-square text-primary ms-1" style="font-size: 0.75rem;"></i>
							</a>
						</td>
						<td class="text-center">
							<span class="badge bg-light text-secondary border">#<%=c.getCategoryId()%></span>
						</td>
						<td class="text-center">
							<a href="display_products.jsp?category=<%=c.getCategoryId()%>" class="btn btn-sm btn-outline-info me-1" title="View products in this category">
								<i class="fa-solid fa-boxes-stacked"></i>
							</a>
							<a href="update_category.jsp?cid=<%=c.getCategoryId()%>" class="btn btn-sm btn-outline-primary me-1" title="Edit category">
								<i class="fa-solid fa-pen-to-square"></i>
							</a>
							<button type="button" class="btn btn-sm btn-outline-danger" data-cid="<%=c.getCategoryId()%>" onclick="confirmDeleteCategory(this.dataset.cid, event)" title="Delete category">
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
					<span class="fw-bold text-white">EazyDeals Category Management</span> &bull; Logged in as: <%=activeAdmin.getEmail()%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>
