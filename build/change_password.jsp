<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Create New Password</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
<script>
function validateChangePassForm(event) {
	event.preventDefault();
	const form = document.forms["changePassForm"];
	const password = form["password"];
	const confirmPassword = form["confirm_password"];

	let valid = true;

	if (!password.value.trim()) {
		showInputError(password, "New password is required.");
		valid = false;
	} else if (password.value.length < 6) {
		showInputError(password, "Password must be at least 6 characters long.");
		valid = false;
	} else {
		clearInputError(password);
	}

	if (!confirmPassword.value.trim()) {
		showInputError(confirmPassword, "Please re-type your password.");
		valid = false;
	} else if (password.value !== confirmPassword.value) {
		showInputError(confirmPassword, "Passwords do not match. Please verify.");
		valid = false;
	} else {
		clearInputError(confirmPassword);
	}

	if (valid) {
		confirmAction({
			title: 'Update Password?',
			text: 'Are you sure you want to update your account password now?',
			icon: 'question',
			confirmText: 'Yes, Save New Password',
			confirmColor: '#2563eb'
		}, function() {
			form.submit();
		});
	}
	return false;
}

function togglePass(inputId, iconId) {
	const p = document.getElementById(inputId);
	const icon = document.getElementById(iconId);
	if (p.type === "password") {
		p.type = "text";
		icon.classList.remove("fa-eye");
		icon.classList.add("fa-eye-slash");
	} else {
		p.type = "password";
		icon.classList.remove("fa-eye-slash");
		icon.classList.add("fa-eye");
	}
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
							<div class="rounded-circle bg-success bg-opacity-10 text-success d-inline-flex align-items-center justify-content-center mb-3" style="width: 64px; height: 64px; font-size: 1.6rem;">
								<i class="fa-solid fa-lock-open"></i>
							</div>
							<h3 class="fw-bold text-dark mb-1">Set New Password</h3>
							<p class="text-muted small">Choose a strong, unique password to secure your EazyDeals account.</p>
						</div>

						<%@include file="Components/alert_message.jsp"%>

						<form name="changePassForm" action="ChangePasswordServlet" method="post" onsubmit="validateChangePassForm(event)" novalidate>
							<div class="mb-3">
								<label class="form-label small fw-semibold text-muted">New Password <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-light text-muted"><i class="fa-solid fa-lock"></i></span>
									<input type="password" id="newPass" name="password" class="form-control" placeholder="Min 6 characters" required>
									<button class="btn btn-outline-secondary" type="button" onclick="togglePass('newPass', 'eyeNewPass')">
										<i class="fa-regular fa-eye" id="eyeNewPass"></i>
									</button>
								</div>
							</div>

							<div class="mb-4">
								<label class="form-label small fw-semibold text-muted">Confirm New Password <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-light text-muted"><i class="fa-solid fa-shield-check"></i></span>
									<input type="password" id="confirmPass" name="confirm_password" class="form-control" placeholder="Re-type password" required>
									<button class="btn btn-outline-secondary" type="button" onclick="togglePass('confirmPass', 'eyeConfirmPass')">
										<i class="fa-regular fa-eye" id="eyeConfirmPass"></i>
									</button>
								</div>
							</div>

							<button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
								<i class="fa-solid fa-circle-check me-1"></i> Update Password
							</button>

							<div class="text-center">
								<a href="login.jsp" class="small text-muted text-decoration-none">
									<i class="fa-solid fa-arrow-left me-1"></i> Cancel &amp; Return to Sign In
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
					<span class="fw-bold text-white">EazyDeals Password Management</span>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>