<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Customer Sign In</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-7 col-lg-5">
				<div class="auth-card">
					<div class="auth-header">
						<div class="mb-3">
							<span class="brand-badge fs-2 p-3"><i class="fa-solid fa-bag-shopping"></i></span>
						</div>
						<h3>Welcome Back</h3>
						<p class="text-muted small mb-0">Sign in to your EazyDeals customer account</p>
					</div>

					<div class="auth-body">
						<%@include file="Components/alert_message.jsp"%>

						<form id="customer-login-form" action="LoginServlet" method="post" onsubmit="return validateCustomerLogin(this, event)">
							<input type="hidden" name="login" value="user">

							<div class="mb-3">
								<label class="form-label" for="userEmail">Email Address</label>
								<div class="input-group">
									<span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-regular fa-envelope"></i></span>
									<input type="email" id="userEmail" name="user_email" placeholder="Enter your email" class="form-control border-start-0 ps-0" autocomplete="email">
								</div>
								<div id="email-error" class="error-message">Valid email address is required!</div>
							</div>

							<div class="mb-3">
								<div class="d-flex justify-content-between align-items-center mb-1">
									<label class="form-label mb-0" for="userPassword">Password</label>
									<a href="forgot_password.jsp" class="small text-decoration-none text-primary fw-semibold">Forgot Password?</a>
								</div>
								<div class="input-group">
									<span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-lock"></i></span>
									<input type="password" id="userPassword" name="user_password" placeholder="Enter your password" class="form-control border-start-0 border-end-0 ps-0" autocomplete="current-password">
									<button class="btn btn-outline-secondary border-start-0 bg-light text-muted" type="button" onclick="togglePasswordVisibility('userPassword', this)" aria-label="Toggle password visibility">
										<i class="fa-regular fa-eye"></i>
									</button>
								</div>
								<div id="password-error" class="error-message">Password is required (minimum 6 characters)!</div>
							</div>

							<div class="d-grid gap-2 mt-4">
								<button type="submit" class="btn btn-primary py-2 fw-semibold">
									<i class="fa-solid fa-arrow-right-to-bracket me-2"></i> Sign In
								</button>
							</div>
						</form>

						<div class="text-center mt-4 pt-3 border-top">
							<p class="text-muted small mb-0">
								Don't have an account? <a href="register.jsp" class="text-primary fw-bold text-decoration-none">Create Account</a>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
	function togglePasswordVisibility(fieldId, btn) {
		const field = document.getElementById(fieldId);
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

	function validateCustomerLogin(form, e) {
		let valid = true;
		const emailField = document.getElementById('userEmail');
		const passwordField = document.getElementById('userPassword');
		const emailError = document.getElementById('email-error');
		const passwordError = document.getElementById('password-error');

		clearInputError(emailField);
		clearInputError(passwordField);

		const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		if (!emailField.value || emailField.value.trim() === '') {
			showInputError(emailField, 'Email address is required!');
			valid = false;
		} else if (!emailRegex.test(emailField.value.trim())) {
			showInputError(emailField, 'Please enter a valid email address (e.g., name@domain.com)!');
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
