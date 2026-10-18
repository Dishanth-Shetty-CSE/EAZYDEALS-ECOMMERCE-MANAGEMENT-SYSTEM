<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Page Not Found (404)</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body class="bg-light">
	<%@include file="Components/navbar.jsp"%>

	<div class="container py-5 text-center">
		<div class="row justify-content-center">
			<div class="col-md-6">
				<div class="card border rounded-4 shadow-sm p-4 p-md-5">
					<img src="Images/no-results.png" class="img-fluid mx-auto mb-3" style="max-width: 220px;" alt="Not Found">
					<h2 class="fw-bold text-dark mb-2">404 - Page Not Found</h2>
					<p class="text-muted small mb-4">The page you were searching for might have been moved, renamed, or is temporarily unavailable.</p>
					<div class="d-flex justify-content-center gap-3">
						<a href="index.jsp" class="btn btn-primary px-4 py-2 fw-semibold">
							<i class="fa-solid fa-house me-1"></i> Return Home
						</a>
						<a href="products.jsp" class="btn btn-outline-secondary px-4 py-2">
							<i class="fa-solid fa-bag-shopping me-1"></i> Browse Products
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>