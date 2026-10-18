<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.entities.Category"%>
<%@page import="com.eazydeals.dao.CategoryDao"%>
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
int cid = 0;
try {
	cid = Integer.parseInt(request.getParameter("cid"));
} catch (Exception e) {
	response.sendRedirect("display_category.jsp");
	return;
}
CategoryDao categoryDao = new CategoryDao(ConnectionProvider.getConnection());
Category category = categoryDao.getCategoryById(cid);
if (category == null) {
	response.sendRedirect("display_category.jsp");
	return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Edit Category #<%=cid%></title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
<script>
function validateUpdateCategoryForm(event) {
	event.preventDefault();
	const form = document.forms["updateCategoryForm"];
	const name = form["category_name"];

	let valid = true;
	if (!name.value.trim()) {
		showInputError(name, "Category name is required.");
		valid = false;
	} else {
		clearInputError(name);
	}

	if (valid) {
		confirmAction({
			title: 'Save Category Changes?',
			text: 'Are you sure you want to update category "' + name.value.trim() + '"?',
			icon: 'question',
			confirmText: 'Yes, Save Changes',
			confirmColor: '#2563eb'
		}, function() {
			form.submit();
		});
	}
	return false;
}

function previewCatImage(event) {
	const file = event.target.files[0];
	if (file) {
		const reader = new FileReader();
		reader.onload = function(e) {
			const preview = document.getElementById("catImagePreview");
			if (preview) {
				preview.src = e.target.result;
			}
		};
		reader.readAsDataURL(file);
	}
}
</script>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Breadcrumbs & Header -->
		<div class="bg-white p-4 rounded-4 border mb-4 shadow-sm">
			<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
				<div>
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-1 small text-muted">
							<li class="breadcrumb-item"><a href="admin.jsp" class="text-decoration-none">Dashboard</a></li>
							<li class="breadcrumb-item"><a href="display_category.jsp" class="text-decoration-none">Categories</a></li>
							<li class="breadcrumb-item active" aria-current="page">Edit Category</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Modify Category</h3>
					<span class="text-muted small">Update category name and banner icon</span>
				</div>
				<a href="display_category.jsp" class="btn btn-outline-secondary btn-sm px-3">
					<i class="fa-solid fa-arrow-left me-1"></i> Back to Categories
				</a>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<div class="row justify-content-center">
			<div class="col-lg-6">
				<div class="card border rounded-4 shadow-sm overflow-hidden">
					<div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
						<div class="d-flex align-items-center gap-2">
							<span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1 rounded-pill">Category #<%=cid%></span>
							<span class="fw-bold text-dark"><%=category.getCategoryName()%></span>
						</div>
					</div>

					<form action="AddOperationServlet?cid=<%=cid%>" method="post" name="updateCategoryForm" enctype="multipart/form-data" onsubmit="validateUpdateCategoryForm(event)" novalidate>
						<input type="hidden" name="operation" value="updateCategory">
						<input type="hidden" name="image" value="<%=category.getCategoryImage()%>">

						<div class="card-body p-4">
							<div class="mb-4">
								<label class="form-label small fw-semibold text-muted">Category Title / Name <span class="text-danger">*</span></label>
								<input type="text" name="category_name" value="<%=category.getCategoryName()%>" class="form-control form-control-lg" required>
							</div>

							<div class="bg-light p-3 rounded-4 border text-center mb-4">
								<label class="form-label small fw-semibold text-muted d-block text-start mb-2">Category Icon / Image</label>
								<div class="bg-white p-3 rounded-3 border d-inline-block shadow-sm mb-3">
									<img id="catImagePreview" src="Product_imgs/<%=category.getCategoryImage()%>" alt="<%=category.getCategoryName()%>" class="img-fluid rounded" style="max-height: 140px; object-fit: contain;" onerror="this.src='Images/empty-cart.png'">
								</div>
								<div class="text-muted small mb-3">
									Current file: <code><%=category.getCategoryImage()%></code>
								</div>
								<div class="text-start">
									<label class="form-label small fw-semibold text-muted">Replace Image (Optional)</label>
									<input class="form-control form-control-sm" type="file" name="category_img" accept="image/*" onchange="previewCatImage(event)">
									<div class="form-text small text-muted">Leave blank to retain current category icon.</div>
								</div>
							</div>

							<div class="d-flex justify-content-between align-items-center pt-2">
								<a href="display_category.jsp" class="btn btn-outline-secondary px-4">Cancel</a>
								<button type="submit" class="btn btn-primary px-5 py-2 fw-semibold">
									<i class="fa-solid fa-floppy-disk me-1"></i> Save Changes
								</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<footer class="footer mt-5">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 text-muted small">
				<div>
					<span class="fw-bold text-white">EazyDeals Category Management</span> &bull; Category ID: <%=cid%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>