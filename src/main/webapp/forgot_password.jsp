<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Reset Password</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
<script>
function validateForgotForm(event) {
	event.preventDefault();
	const form = document.forms["forgotForm"];
	const email = form["email"];

	const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (!email.value.trim()) {
		showInputError(email, "Please provide your registered account email.");
		return false;
	} else if (!emailRegex.test(email.value.trim())) {
		showInputError(email, "Please enter a valid email address.");
		return false;
	} else {
		clearInputError(email);
	}

	confirmAction({
		title: 'Request OTP Code?',
		text: 'We will send a 6-digit verification code to ' + email.value.trim(),
		icon: 'question',
		confirmText: 'Send Verification Code',
		confirmColor: '#2563eb'
	}, function() {
		form.submit();
	});
	return false;
}
</script>
</head>
<body class="bg-light">

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-7 col-lg-5 col-xl-4">
				<div class="card border rounded-4 shadow-sm overflow-hidden">
					<div class="card-body p-4 p-md-5">
						<div class="text-center mb-4">
							<div class="rounded-circle bg-primary bg-opacity-10 text-primary d-inline-flex align-items-center justify-content-center mb-3" style="width: 64px; height: 64px; font-size: 1.6rem;">
								<i class="fa-solid fa-key"></i>
							</div>
							<h3 class="fw-bold text-dark mb-1">Forgot Password?</h3>
							<p class="text-muted small">Enter your registered email address and we'll send you an OTP to reset your credentials.</p>
						</div>

						<%@include file="Components/alert_message.jsp"%>

						<form name="forgotForm" action="ChangePasswordServlet" method="post" onsubmit="validateForgotForm(event)" novalidate>
							<div class="mb-4">
								<label class="form-label small fw-semibold text-muted">Registered Email Address <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-light text-muted"><i class="fa-regular fa-envelope"></i></span>
									<input type="email" name="email" class="form-control" placeholder="name@domain.com" required>
								</div>
							</div>

							<button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
								<i class="fa-solid fa-paper-plane me-1"></i> Send Verification Code
							</button>

							<div class="text-center">
								<a href="login.jsp" class="small text-muted text-decoration-none">
									<i class="fa-solid fa-arrow-left me-1"></i> Return to Sign In
								</a>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<footer class="footer mt-auto">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 text-muted small">
				<div>
					<span class="fw-bold text-white">EazyDeals Security Portal</span> &bull; Password Assistance
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>