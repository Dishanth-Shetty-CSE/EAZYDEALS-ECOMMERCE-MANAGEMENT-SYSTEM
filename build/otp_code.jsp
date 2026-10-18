<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Two-Step Verification</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
<script>
function validateOTPForm(event) {
	event.preventDefault();
	const form = document.forms["otpForm"];
	const code = form["code"];

	const codeVal = code.value.trim();
	if (!codeVal) {
		showInputError(code, "Please enter the 6-digit verification code.");
		return false;
	} else if (codeVal.length !== 6 || !/^\d{6}$/.test(codeVal)) {
		showInputError(code, "Verification code must be exactly 6 numeric digits.");
		return false;
	} else {
		clearInputError(code);
	}

	confirmAction({
		title: 'Verify Code?',
		text: 'Submit code ' + codeVal + ' to verify your account identity?',
		icon: 'question',
		confirmText: 'Verify Code',
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
								<i class="fa-solid fa-shield-halved"></i>
							</div>
							<h3 class="fw-bold text-dark mb-1">Verify Identity</h3>
							<p class="text-muted small">Enter the 6-digit security code sent to your registered email address.</p>
						</div>

						<%@include file="Components/alert_message.jsp"%>

						<form name="otpForm" action="ChangePasswordServlet" method="post" onsubmit="validateOTPForm(event)" novalidate>
							<div class="mb-4">
								<label class="form-label small fw-semibold text-muted text-center d-block">6-Digit Security OTP <span class="text-danger">*</span></label>
								<input type="text" name="code" maxlength="6" inputmode="numeric" class="form-control form-control-lg text-center fw-bold fs-4 tracking-wider" placeholder="&bull; &bull; &bull; &bull; &bull; &bull;" style="letter-spacing: 0.35rem;" required autofocus>
							</div>

							<button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
								<i class="fa-solid fa-check-circle me-1"></i> Verify &amp; Proceed
							</button>

							<div class="text-center small text-muted">
								Didn't receive the OTP? 
								<a href="ResendOtpServlet" class="text-primary fw-semibold text-decoration-none">
									<i class="fa-solid fa-rotate-right me-1"></i> Resend Code
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
					<span class="fw-bold text-white">EazyDeals Identity Verification</span>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>
