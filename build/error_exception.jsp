<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | System Notice</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body class="bg-light">
	<%@include file="Components/navbar.jsp"%>

	<div class="container py-5 text-center">
		<div class="row justify-content-center">
			<div class="col-md-6">
				<div class="card border rounded-4 shadow-sm p-4 p-md-5">
					<div class="rounded-circle bg-warning bg-opacity-10 text-warning d-inline-flex align-items-center justify-content-center mx-auto mb-3" style="width: 72px; height: 72px; font-size: 2rem;">
						<i class="fa-solid fa-triangle-exclamation"></i>
					</div>
					<h3 class="fw-bold text-dark mb-2">Something Went Wrong</h3>
					<p class="text-muted small mb-3">An unexpected event occurred while processing your request. Please try again or return to the homepage.</p>
					<% if (exception != null && exception.getMessage() != null) { %>
					<div class="alert alert-light border text-danger small text-start font-monospace mb-4">
						<%=exception.getMessage()%>
					</div>
					<% } %>
					<div class="d-flex justify-content-center gap-3">
						<a href="index.jsp" class="btn btn-primary px-4 py-2 fw-semibold">
							<i class="fa-solid fa-house me-1"></i> Home Page
						</a>
						<a href="javascript:history.back()" class="btn btn-outline-secondary px-4 py-2">
							<i class="fa-solid fa-arrow-left me-1"></i> Go Back
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>