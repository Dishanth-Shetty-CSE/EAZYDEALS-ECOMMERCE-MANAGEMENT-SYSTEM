<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Customer Registration</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-9 col-lg-7">
				<div class="auth-card" style="max-width: 680px;">
					<div class="auth-header">
						<div class="mb-3">
							<span class="brand-badge fs-2 p-3"><i class="fa-solid fa-user-plus"></i></span>
						</div>
						<h3>Create an Account</h3>
						<p class="text-muted small mb-0">Join EazyDeals to enjoy exclusive deals and express checkout</p>
					</div>

					<div class="auth-body">
						<%@include file="Components/alert_message.jsp"%>

						<form id="customer-register-form" action="RegisterServlet" method="post" onsubmit="return validateCustomerRegister(this, event)">
							<div class="row g-3 mb-3">
								<div class="col-md-6">
									<label class="form-label" for="regName">Full Name</label>
									<input type="text" id="regName" name="user_name" class="form-control" placeholder="Enter first and last name" autocomplete="name">
									<div id="name-error" class="error-message">Full name is required!</div>
								</div>
								<div class="col-md-6">
									<label class="form-label" for="regEmail">Email Address</label>
									<input type="email" id="regEmail" name="user_email" placeholder="e.g. name@example.com" class="form-control" autocomplete="email">
									<div id="email-error" class="error-message">Valid email address is required!</div>
								</div>
							</div>

							<div class="row g-3 mb-3">
								<div class="col-md-6">
									<label class="form-label" for="regMobile">Mobile Number</label>
									<input type="tel" id="regMobile" name="user_mobile_no" placeholder="10-digit mobile number" maxlength="10" class="form-control" autocomplete="tel">
									<div id="mobile-error" class="error-message">Valid 10-digit mobile number is required!</div>
								</div>
								<div class="col-md-6">
									<label class="form-label d-block mb-2">Gender</label>
									<div class="d-flex align-items-center gap-4 mt-2">
										<div class="form-check">
											<input class="form-check-input" type="radio" name="gender" id="genderMale" value="Male">
											<label class="form-check-label fw-normal" for="genderMale">Male</label>
										</div>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="gender" id="genderFemale" value="Female">
											<label class="form-check-label fw-normal" for="genderFemale">Female</label>
										</div>
									</div>
									<div id="gender-error" class="error-message">Please select your gender!</div>
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label" for="regAddress">Street Address</label>
								<input type="text" id="regAddress" name="user_address" placeholder="House/Flat No., Building, Area and Street" class="form-control" autocomplete="street-address">
								<div id="address-error" class="error-message">Street address is required!</div>
							</div>

							<div class="row g-3 mb-3">
								<div class="col-md-6">
									<label class="form-label" for="regCity">City / Town</label>
									<input class="form-control" type="text" id="regCity" name="city" placeholder="e.g. Mumbai, Bangalore">
									<div id="city-error" class="error-message">City / Town is required!</div>
								</div>
								<div class="col-md-6">
									<label class="form-label" for="regPincode">Pincode</label>
									<input class="form-control" type="text" id="regPincode" name="pincode" placeholder="6-digit pincode" maxlength="6">
									<div id="pincode-error" class="error-message">Valid 6-digit pincode is required!</div>
								</div>
							</div>

							<div class="row g-3 mb-3">
								<div class="col-md-6">
									<label class="form-label" for="regState">State</label>
									<select name="state" id="regState" class="form-select">
										<option value="" selected disabled>- Select State -</option>
										<option value="Andhra Pradesh">Andhra Pradesh</option>
										<option value="Arunachal Pradesh">Arunachal Pradesh</option>
										<option value="Assam">Assam</option>
										<option value="Bihar">Bihar</option>
										<option value="Chandigarh">Chandigarh</option>
										<option value="Chhattisgarh">Chhattisgarh</option>
										<option value="Delhi">Delhi</option>
										<option value="Goa">Goa</option>
										<option value="Gujarat">Gujarat</option>
										<option value="Haryana">Haryana</option>
										<option value="Himachal Pradesh">Himachal Pradesh</option>
										<option value="Jammu & Kashmir">Jammu & Kashmir</option>
										<option value="Jharkhand">Jharkhand</option>
										<option value="Karnataka">Karnataka</option>
										<option value="Kerala">Kerala</option>
										<option value="Madhya Pradesh">Madhya Pradesh</option>
										<option value="Maharashtra">Maharashtra</option>
										<option value="Manipur">Manipur</option>
										<option value="Meghalaya">Meghalaya</option>
										<option value="Mizoram">Mizoram</option>
										<option value="Nagaland">Nagaland</option>
										<option value="Odisha">Odisha</option>
										<option value="Punjab">Punjab</option>
										<option value="Rajasthan">Rajasthan</option>
										<option value="Sikkim">Sikkim</option>
										<option value="Tamil Nadu">Tamil Nadu</option>
										<option value="Telangana">Telangana</option>
										<option value="Tripura">Tripura</option>
										<option value="Uttarakhand">Uttarakhand</option>
										<option value="Uttar Pradesh">Uttar Pradesh</option>
										<option value="West Bengal">West Bengal</option>
									</select>
									<div id="state-error" class="error-message">Please select your state!</div>
								</div>
								<div class="col-md-6">
									<label class="form-label" for="regPassword">Password</label>
									<input type="password" id="regPassword" name="user_password" placeholder="Minimum 6 characters" class="form-control" autocomplete="new-password">
									<div id="password-error" class="error-message">Password is required (minimum 6 characters)!</div>
								</div>
							</div>

							<div class="d-grid gap-2 mt-4">
								<button type="submit" class="btn btn-primary py-2 fw-semibold">
									<i class="fa-solid fa-check-circle me-2"></i> Register Account
								</button>
								<button type="reset" class="btn btn-outline-secondary py-2">
									Clear Fields
								</button>
							</div>

							<div class="text-center mt-4 pt-3 border-top">
								<p class="text-muted small mb-0">
									Already have an account? <a href="login.jsp" class="text-primary fw-bold text-decoration-none">Sign In Here</a>
								</p>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
	function validateCustomerRegister(form, e) {
		let valid = true;

		const nameField = document.getElementById('regName');
		const emailField = document.getElementById('regEmail');
		const mobileField = document.getElementById('regMobile');
		const addressField = document.getElementById('regAddress');
		const cityField = document.getElementById('regCity');
		const pincodeField = document.getElementById('regPincode');
		const stateField = document.getElementById('regState');
		const passwordField = document.getElementById('regPassword');
		const genderInputs = document.querySelectorAll('input[name="gender"]');

		// Clear previous errors
		[nameField, emailField, mobileField, addressField, cityField, pincodeField, stateField, passwordField].forEach(clearInputError);
		document.getElementById('gender-error').style.display = 'none';

		// 1. Name
		if (!nameField.value || nameField.value.trim() === '') {
			showInputError(nameField, 'Full name is required!');
			valid = false;
		}

		// 2. Email
		const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		if (!emailField.value || emailField.value.trim() === '') {
			showInputError(emailField, 'Email address is required!');
			valid = false;
		} else if (!emailRegex.test(emailField.value.trim())) {
			showInputError(emailField, 'Please enter a valid email address (e.g., name@example.com)!');
			valid = false;
		}

		// 3. Mobile
		const mobileClean = mobileField.value ? mobileField.value.trim() : '';
		if (!mobileClean) {
			showInputError(mobileField, 'Mobile number is required!');
			valid = false;
		} else if (!/^\d{10}$/.test(mobileClean)) {
			showInputError(mobileField, 'Please enter a valid 10-digit mobile number!');
			valid = false;
		}

		// 4. Gender
		let genderChecked = false;
		genderInputs.forEach(g => { if (g.checked) genderChecked = true; });
		if (!genderChecked) {
			document.getElementById('gender-error').style.display = 'block';
			valid = false;
		}

		// 5. Address
		if (!addressField.value || addressField.value.trim() === '') {
			showInputError(addressField, 'Street address is required!');
			valid = false;
		}

		// 6. City
		if (!cityField.value || cityField.value.trim() === '') {
			showInputError(cityField, 'City / Town is required!');
			valid = false;
		}

		// 7. Pincode
		const pinClean = pincodeField.value ? pincodeField.value.trim() : '';
		if (!pinClean) {
			showInputError(pincodeField, 'Pincode is required!');
			valid = false;
		} else if (!/^\d{6}$/.test(pinClean)) {
			showInputError(pincodeField, 'Please enter a valid 6-digit pincode!');
			valid = false;
		}

		// 8. State
		if (!stateField.value || stateField.value === '') {
			showInputError(stateField, 'Please select your state!');
			valid = false;
		}

		// 9. Password
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

		e.preventDefault();
		confirmAction({
			title: 'Create Account',
			text: 'Are you sure you want to register with email: "' + emailField.value.trim() + '"?',
			icon: 'question',
			confirmText: 'Yes, Register Now'
		}, function () {
			form.submit();
		});
		return false;
	}
	</script>
</body>
</html>
