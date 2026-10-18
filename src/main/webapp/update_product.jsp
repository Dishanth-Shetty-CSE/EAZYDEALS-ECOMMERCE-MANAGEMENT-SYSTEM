<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.entities.Category"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
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
int pid = 0;
try {
	pid = Integer.parseInt(request.getParameter("pid"));
} catch (Exception e) {
	response.sendRedirect("display_products.jsp");
	return;
}
ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
Product product = productDao.getProductsByProductId(pid);
if (product == null) {
	response.sendRedirect("display_products.jsp");
	return;
}
CategoryDao catDaoLocal = new CategoryDao(ConnectionProvider.getConnection());
List<Category> allCategories = catDaoLocal.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Edit Product #<%=pid%></title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
<script>
function validateUpdateProductForm(event) {
	event.preventDefault();
	const form = document.forms["updateProductForm"];
	const name = form["name"];
	const price = form["price"];
	const quantity = form["quantity"];
	const discount = form["discount"];

	let valid = true;

	if (!name.value.trim()) {
		showInputError(name, "Product title is required.");
		valid = false;
	} else {
		clearInputError(name);
	}

	if (!price.value || parseFloat(price.value) <= 0) {
		showInputError(price, "Please enter a valid price greater than zero.");
		valid = false;
	} else {
		clearInputError(price);
	}

	if (quantity.value === "" || parseInt(quantity.value) < 0) {
		showInputError(quantity, "Stock quantity cannot be negative.");
		valid = false;
	} else {
		clearInputError(quantity);
	}

	if (discount.value === "" || parseFloat(discount.value) < 0 || parseFloat(discount.value) > 100) {
		showInputError(discount, "Discount must be between 0% and 100%.");
		valid = false;
	} else {
		clearInputError(discount);
	}

	if (valid) {
		confirmAction({
			title: 'Save Product Changes?',
			text: 'Are you sure you want to update details for "' + name.value.trim() + '"?',
			icon: 'question',
			confirmText: 'Yes, Save Changes',
			confirmColor: '#2563eb'
		}, function() {
			form.submit();
		});
	}
	return false;
}

function previewNewImage(event) {
	const file = event.target.files[0];
	if (file) {
		const reader = new FileReader();
		reader.onload = function(e) {
			const preview = document.getElementById("productImagePreview");
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
							<li class="breadcrumb-item"><a href="display_products.jsp" class="text-decoration-none">Inventory</a></li>
							<li class="breadcrumb-item active" aria-current="page">Edit Product</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Modify Product Details</h3>
					<span class="text-muted small">Update pricing, description, stock units, and product media</span>
				</div>
				<div class="d-flex gap-2">
					<a href="display_products.jsp" class="btn btn-outline-secondary btn-sm px-3">
						<i class="fa-solid fa-arrow-left me-1"></i> Back to Inventory
					</a>
					<a href="viewProduct.jsp?pid=<%=pid%>" target="_blank" class="btn btn-outline-primary btn-sm px-3">
						<i class="fa-solid fa-arrow-up-right-from-square me-1"></i> Storefront View
					</a>
				</div>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<div class="row justify-content-center">
			<div class="col-lg-10">
				<div class="card border rounded-4 shadow-sm overflow-hidden">
					<div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
						<div class="d-flex align-items-center gap-2">
							<span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1 rounded-pill">ID #<%=product.getProductId()%></span>
							<span class="fw-bold text-dark"><%=product.getProductName()%></span>
						</div>
						<span class="text-muted small">Category ID: <%=product.getCategoryId()%></span>
					</div>

					<form action="AddOperationServlet?pid=<%=pid%>" method="post" name="updateProductForm" enctype="multipart/form-data" onsubmit="validateUpdateProductForm(event)" novalidate>
						<input type="hidden" name="operation" value="updateProduct">
						<input type="hidden" name="image" value="<%=product.getProductImages()%>">
						<input type="hidden" name="category" value="<%=product.getCategoryId()%>">

						<div class="card-body p-4 p-md-5">
							<div class="row g-4">
								<!-- Left Column: Details -->
								<div class="col-lg-8">
									<div class="mb-3">
										<label class="form-label small fw-semibold text-muted">Product Title / Name <span class="text-danger">*</span></label>
										<input type="text" name="name" value="<%=product.getProductName()%>" class="form-control form-control-lg" required>
									</div>

									<div class="mb-3">
										<label class="form-label small fw-semibold text-muted">Category Selection <span class="text-danger">*</span></label>
										<select name="categoryType" class="form-select">
											<%
											for (Category c : allCategories) {
											%>
											<option value="<%=c.getCategoryId()%>" <%=product.getCategoryId() == c.getCategoryId() ? "selected" : ""%>>
												<%=c.getCategoryName()%>
											</option>
											<%
											}
											%>
										</select>
									</div>

									<div class="mb-3">
										<label class="form-label small fw-semibold text-muted">Detailed Product Description</label>
										<textarea class="form-control" name="description" rows="5" placeholder="Enter key specifications, warranty, dimensions, and highlights..."><%=product.getProductDescription()%></textarea>
									</div>

									<div class="row g-3">
										<div class="col-md-4">
											<label class="form-label small fw-semibold text-muted">Original Price (&#8377;) <span class="text-danger">*</span></label>
											<div class="input-group">
												<span class="input-group-text">&#8377;</span>
												<input type="number" step="0.01" min="1" name="price" value="<%=product.getProductPrice()%>" class="form-control" required>
											</div>
										</div>
										<div class="col-md-4">
											<label class="form-label small fw-semibold text-muted">Discount Percentage (%)</label>
											<div class="input-group">
												<input type="number" min="0" max="100" name="discount" value="<%=product.getProductDiscount()%>" class="form-control" required>
												<span class="input-group-text">%</span>
											</div>
										</div>
										<div class="col-md-4">
											<label class="form-label small fw-semibold text-muted">Available Stock Units <span class="text-danger">*</span></label>
											<input type="number" min="0" name="quantity" value="<%=product.getProductQunatity()%>" class="form-control" required>
										</div>
									</div>
								</div>

								<!-- Right Column: Image Preview & Upload -->
								<div class="col-lg-4">
									<div class="bg-light p-3 rounded-4 border text-center h-100 d-flex flex-column justify-content-between">
										<div>
											<label class="form-label small fw-semibold text-muted d-block text-start mb-2">Product Image</label>
											<div class="bg-white p-3 rounded-3 border d-inline-block shadow-sm mb-3">
												<img id="productImagePreview" src="Product_imgs/<%=product.getProductImages()%>" alt="<%=product.getProductName()%>" class="img-fluid rounded" style="max-height: 220px; object-fit: contain;" onerror="this.src='Images/empty-cart.png'">
											</div>
											<div class="text-muted small mb-3">
												Current file: <code><%=product.getProductImages()%></code>
											</div>
										</div>

										<div>
											<label class="form-label small fw-semibold text-muted text-start d-block">Replace Image (Optional)</label>
											<input class="form-control form-control-sm" type="file" name="product_img" accept="image/*" onchange="previewNewImage(event)">
											<div class="form-text small text-muted text-start mt-1">Leave blank to retain current product image.</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="card-footer bg-white p-4 border-top d-flex justify-content-between align-items-center">
							<a href="display_products.jsp" class="btn btn-outline-secondary px-4">Cancel</a>
							<button type="submit" class="btn btn-primary px-5 py-2 fw-semibold">
								<i class="fa-solid fa-floppy-disk me-1"></i> Save Changes
							</button>
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
					<span class="fw-bold text-white">EazyDeals Inventory Management</span> &bull; Product ID: <%=pid%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>