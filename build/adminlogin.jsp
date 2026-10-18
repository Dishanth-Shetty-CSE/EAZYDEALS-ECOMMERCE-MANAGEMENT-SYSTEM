<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Administrator Sign In</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);">

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-7 col-lg-5">
				<div class="auth-card shadow-lg" style="border: 1px solid rgba(255, 255, 255, 0.1);">
					<div class="auth-header">
						<div class="mb-3">
							<span class="brand-badge fs-2 p-3" style="background: linear-gradient(135deg, #0284c7, #0369a1);"><i class="fa-solid fa-shield-halved"></i></span>
						</div>
						<h3>Admin Management</h3>
						<p class="text-muted small mb-0">Authorized personnel only</p>
					</div>

					<div class="auth-body">
						<%@include file="Components/alert_message.jsp"%>

						<form id="admin-login-form" action="LoginServlet" method="post" onsubmit="return validateAdminLogin(this, event)">
							<input type="hidden" name="login" value="admin">

							<div class="mb-3">
								<label class="form-label" for="adminEmail">Administrator Email</label>
								<div class="input-group">
									<span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-regular fa-envelope"></i></span>
									<input type="email" id="adminEmail" name="email" placeholder="Enter admin email address" class="form-control border-start-0 ps-0" autocomplete="email">
								</div>
								<div id="email-error" class="error-message">Valid administrator email is required!</div>
							</div>

							<div class="mb-3">
								<label class="form-label" for="adminPassword">Password</label>
								<div class="input-group">
									<span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-lock"></i></span>
									<input type="password" id="adminPassword" name="password" placeholder="Enter password" class="form-control border-start-0 border-end-0 ps-0" autocomplete="current-password">
									<button class="btn btn-outline-secondary border-start-0 bg-light text-muted" type="button" onclick="toggleAdminPasswordVisibility(this)" aria-label="Toggle password visibility">
										<i class="fa-regular fa-eye"></i>
									</button>
								</div>
								<div id="password-error" class="error-message">Password is required (minimum 6 characters)!</div>
							</div>

							<div class="d-grid gap-2 mt-4">
								<button type="submit" class="btn btn-primary py-2 fw-semibold" style="background-color: #0284c7; border-color: #0284c7;">
									<i class="fa-solid fa-shield-halved me-2"></i> Access Dashboard
								</button>
							</div>
						</form>

						<div class="text-center mt-4 pt-3 border-top">
							<a href="login.jsp" class="text-muted small text-decoration-none">
								<i class="fa-solid fa-arrow-left me-1"></i> Return to Customer Login
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
	function toggleAdminPasswordVisibility(btn) {
		const field = document.getElementById('adminPassword');
		const icon = btn.querySelector('i');
		if (field.type === 'password') {
			field.type = 'text';
			icon.classList.remove('fa-eye');
			icon.classList.add('fa-eye-slash');
		} else {
			field.type = 'password';
			icon.classList.remove('fa-eye-slash');
			icon.classList.add('fa-eye');
		}
	}

	function validateAdminLogin(form, e) {
		let valid = true;
		const emailField = document.getElementById('adminEmail');
		const passwordField = document.getElementById('adminPassword');

		clearInputError(emailField);
		clearInputError(passwordField);

		const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		if (!emailField.value || emailField.value.trim() === '') {
			showInputError(emailField, 'Administrator email address is required!');
			valid = false;
		} else if (!emailRegex.test(emailField.value.trim())) {
			showInputError(emailField, 'Please enter a valid email format!');
			valid = false;
		}

		if (!passwordField.value || passwordField.value.trim() === '') {
			showInputError(passwordField, 'Password is required!');
			valid = false;
		} else if (passwordField.value.length < 6) {
			showInputError(passwordField, 'Password must be at least 6 characters long!');
			valid = false;
		}

		if (!valid) {
			e.preventDefault();
			return false;
		}

		return true;
	}
	</script>
</body>
</html>
