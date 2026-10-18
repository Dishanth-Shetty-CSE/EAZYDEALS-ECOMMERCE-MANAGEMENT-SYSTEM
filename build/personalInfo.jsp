<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.entities.User"%>
<%
User user1 = (User) session.getAttribute("activeUser");
if (user1 == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("login.jsp");
	return;
}
%>
<div class="p-4">
	<h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
		<i class="fa-regular fa-id-card text-primary"></i> Personal Profile Information
	</h4>
	<p class="text-muted small mb-4">Manage your personal contact information and delivery address preferences</p>

	<form id="update-user-form" action="UpdateUserServlet" method="post" onsubmit="return handleUpdateProfile(this, event)">
		<input type="hidden" name="operation" value="updateUser">

		<div class="row g-3 mb-3">
			<div class="col-md-6">
				<label class="form-label" for="profName">Full Name</label>
				<input type="text" id="profName" name="name" class="form-control" value="<%=user1.getUserName()%>">
				<div id="profNameError" class="error-message">Full name is required!</div>
			</div>
			<div class="col-md-6">
				<label class="form-label" for="profEmail">Email Address</label>
				<input type="email" id="profEmail" name="email" class="form-control" value="<%=user1.getUserEmail()%>">
				<div id="profEmailError" class="error-message">Valid email address is required!</div>
			</div>
		</div>

		<div class="row g-3 mb-3">
			<div class="col-md-6">
				<label class="form-label" for="profMobile">Mobile Number</label>
				<input type="tel" id="profMobile" name="mobile_no" class="form-control" maxlength="10" value="<%=user1.getUserPhone()%>">
				<div id="profMobileError" class="error-message">Valid 10-digit mobile number is required!</div>
			</div>
			<div class="col-md-6">
				<label class="form-label d-block mb-2">Gender</label>
				<div class="d-flex align-items-center gap-4 mt-2">
					<%
					String gender = user1.getUserGender();
					if (gender == null) gender = "Male";
					boolean isMale = "Male".equalsIgnoreCase(gender.trim());
					%>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="gender" id="pGenderMale" value="Male" <%=isMale ? "checked" : ""%>>
						<label class="form-check-label fw-normal" for="pGenderMale">Male</label>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="gender" id="pGenderFemale" value="Female" <%=!isMale ? "checked" : ""%>>
						<label class="form-check-label fw-normal" for="pGenderFemale">Female</label>
					</div>
				</div>
			</div>
		</div>

		<div class="mb-3">
			<label class="form-label" for="profAddress">Street Address</label>
			<input type="text" id="profAddress" name="address" class="form-control" value="<%=user1.getUserAddress()%>">
			<div id="profAddressError" class="error-message">Street address is required!</div>
		</div>

		<div class="row g-3 mb-3">
			<div class="col-md-6">
				<label class="form-label" for="profCity">City / Town</label>
				<input class="form-control" type="text" id="profCity" name="city" value="<%=user1.getUserCity()%>">
				<div id="profCityError" class="error-message">City is required!</div>
			</div>
			<div class="col-md-6">
				<label class="form-label" for="profPincode">Pincode</label>
				<input class="form-control" type="text" id="profPincode" name="pincode" maxlength="6" value="<%=user1.getUserPincode()%>">
				<div id="profPincodeError" class="error-message">Valid 6-digit pincode is required!</div>
			</div>
		</div>

		<div class="mb-4">
			<label class="form-label" for="profState">State</label>
			<select name="state" id="profState" class="form-select">
				<option value="<%=user1.getUserState()%>" selected><%=user1.getUserState()%></option>
				<option value="Andhra Pradesh">Andhra Pradesh</option>
				<option value="Assam">Assam</option>
				<option value="Bihar">Bihar</option>
				<option value="Delhi">Delhi</option>
				<option value="Goa">Goa</option>
				<option value="Gujarat">Gujarat</option>
				<option value="Karnataka">Karnataka</option>
				<option value="Kerala">Kerala</option>
				<option value="Maharashtra">Maharashtra</option>
				<option value="Punjab">Punjab</option>
				<option value="Rajasthan">Rajasthan</option>
				<option value="Tamil Nadu">Tamil Nadu</option>
				<option value="Telangana">Telangana</option>
				<option value="Uttar Pradesh">Uttar Pradesh</option>
				<option value="West Bengal">West Bengal</option>
			</select>
			<div id="profStateError" class="error-message">State is required!</div>
		</div>

		<div class="d-flex justify-content-end">
			<button type="submit" class="btn btn-primary px-4 py-2">
				<i class="fa-solid fa-floppy-disk me-2"></i> Save Changes
			</button>
		</div>
	</form>
</div>

<script>
function handleUpdateProfile(form, e) {
	let valid = true;
	const name = document.getElementById("profName");
	const email = document.getElementById("profEmail");
	const mobile = document.getElementById("profMobile");
	const address = document.getElementById("profAddress");
	const city = document.getElementById("profCity");
	const pincode = document.getElementById("profPincode");
	const state = document.getElementById("profState");

	[name, email, mobile, address, city, pincode, state].forEach(clearInputError);

	if (!name.value || name.value.trim() === "") {
		showInputError(name, "Full name is required!");
		valid = false;
	}

	const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (!email.value || email.value.trim() === "") {
		showInputError(email, "Email address is required!");
		valid = false;
	} else if (!emailRegex.test(email.value.trim())) {
		showInputError(email, "Please enter a valid email address!");
		valid = false;
	}

	const mobClean = mobile.value ? mobile.value.trim() : "";
	if (!mobClean || !/^\d{10}$/.test(mobClean)) {
		showInputError(mobile, "Valid 10-digit mobile number is required!");
		valid = false;
	}

	if (!address.value || address.value.trim() === "") {
		showInputError(address, "Street address is required!");
		valid = false;
	}

	if (!city.value || city.value.trim() === "") {
		showInputError(city, "City is required!");
		valid = false;
	}

	const pinClean = pincode.value ? pincode.value.trim() : "";
	if (!pinClean || !/^\d{6}$/.test(pinClean)) {
		showInputError(pincode, "Valid 6-digit pincode is required!");
		valid = false;
	}

	if (!state.value || state.value === "") {
		showInputError(state, "State is required!");
		valid = false;
	}

	if (!valid) {
		e.preventDefault();
		return false;
	}

	e.preventDefault();
	confirmAction({
		title: 'Update Profile',
		text: 'Are you sure you want to save changes to your profile details?',
		icon: 'question',
		confirmText: 'Yes, Save Changes'
	}, function() {
		form.submit();
	});
	return false;
}
</script>
