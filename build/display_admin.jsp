<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.dao.AdminDao"%>
<%@page import="com.eazydeals.entities.Admin"%>
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
AdminDao adminDao = new AdminDao(ConnectionProvider.getConnection());
List<Admin> adminList = adminDao.getAllAdmin();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Admin Management</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
<script>
function validateAdminForm(event) {
	event.preventDefault();
	const form = document.forms["adminForm"];
	const name = form["name"];
	const email = form["email"];
	const password = form["password"];
	const phone = form["phone"];

	let valid = true;

	if (!name.value.trim()) {
		showInputError(name, "Full name is required.");
		valid = false;
	} else {
		clearInputError(name);
	}

	const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (!email.value.trim()) {
		showInputError(email, "Email address is required.");
		valid = false;
	} else if (!emailRegex.test(email.value.trim())) {
		showInputError(email, "Please enter a valid email address.");
		valid = false;
	} else {
		clearInputError(email);
	}

	if (!password.value.trim()) {
		showInputError(password, "Password is required.");
		valid = false;
	} else if (password.value.length < 6) {
		showInputError(password, "Password must be at least 6 characters long.");
		valid = false;
	} else {
		clearInputError(password);
	}

	const phoneRegex = /^[0-9]{10}$/;
	if (!phone.value.trim()) {
		showInputError(phone, "10-digit mobile number is required.");
		valid = false;
	} else if (!phoneRegex.test(phone.value.trim())) {
		showInputError(phone, "Please enter a valid 10-digit phone number.");
		valid = false;
	} else {
		clearInputError(phone);
	}

	if (valid) {
		confirmAction({
			title: 'Grant Admin Privileges?',
			text: 'Are you sure you want to register ' + name.value.trim() + ' as a system administrator?',
			icon: 'question',
			confirmText: 'Yes, Add Admin',
			confirmColor: '#2563eb'
		}, function() {
			form.submit();
		});
	}
	return false;
}

function toggleAdminPass() {
	const p = document.getElementById("adminPassInput");
	const icon = document.getElementById("adminPassIcon");
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
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Header Banner -->
		<div class="bg-white p-4 rounded-4 border mb-4 shadow-sm">
			<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
				<div>
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-1 small text-muted">
							<li class="breadcrumb-item"><a href="admin.jsp" class="text-decoration-none">Dashboard</a></li>
							<li class="breadcrumb-item active" aria-current="page">Admin Management</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">System Administrators (<%=adminList != null ? adminList.size() : 0%>)</h3>
					<span class="text-muted small">Manage administrative staff and grant portal privileges</span>
				</div>
				<a href="admin.jsp" class="btn btn-outline-secondary btn-sm px-3">
					<i class="fa-solid fa-arrow-left me-1"></i> Dashboard
				</a>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<div class="row g-4">
			<!-- Add Admin Form Card -->
			<div class="col-lg-4">
				<div class="card border rounded-4 shadow-sm sticky-top" style="top: 90px;">
					<div class="card-body p-4">
						<div class="d-flex align-items-center gap-3 mb-3 pb-3 border-bottom">
							<div class="rounded-circle bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; font-size: 1.3rem;">
								<i class="fa-solid fa-user-shield"></i>
							</div>
							<div>
								<h5 class="fw-bold mb-0 text-dark">Add New Admin</h5>
								<small class="text-muted">Create administrative credentials</small>
							</div>
						</div>

						<form name="adminForm" action="AdminServlet?operation=save" method="post" onsubmit="validateAdminForm(event)" novalidate>
							<div class="mb-3">
								<label class="form-label small fw-semibold text-muted">Full Name <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-light text-muted"><i class="fa-regular fa-user"></i></span>
									<input type="text" name="name" class="form-control" placeholder="e.g. Johnathan Doe" required>
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-semibold text-muted">Email Address <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-light text-muted"><i class="fa-regular fa-envelope"></i></span>
									<input type="email" name="email" class="form-control" placeholder="admin@eazydeals.com" required>
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-semibold text-muted">Secure Password <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-light text-muted"><i class="fa-solid fa-lock"></i></span>
									<input type="password" id="adminPassInput" name="password" class="form-control" placeholder="Min 6 characters" required>
									<button class="btn btn-outline-secondary" type="button" onclick="toggleAdminPass()">
										<i class="fa-regular fa-eye" id="adminPassIcon"></i>
									</button>
								</div>
								<div class="form-text small text-muted">Password will be securely hashed with SHA-256.</div>
							</div>

							<div class="mb-4">
								<label class="form-label small fw-semibold text-muted">10-Digit Phone <span class="text-danger">*</span></label>
								<div class="input-group">
									<span class="input-group-text bg-light text-muted"><i class="fa-solid fa-phone"></i></span>
									<input type="tel" name="phone" maxlength="10" class="form-control" placeholder="9876543210" required>
								</div>
							</div>

							<button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
								<i class="fa-solid fa-user-plus me-1"></i> Register Admin
							</button>
						</form>
					</div>
				</div>
			</div>

			<!-- Administrators Table -->
			<div class="col-lg-8">
				<div class="card border rounded-4 shadow-sm">
					<div class="card-header bg-white py-3 border-bottom">
						<div class="d-flex justify-content-between align-items-center">
							<span class="fw-bold text-dark">Active Administrators</span>
							<span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-pill"><%=adminList != null ? adminList.size() : 0%> Accounts</span>
						</div>
					</div>
					<div class="card-body p-0">
						<%
						if (adminList == null || adminList.isEmpty()) {
						%>
						<div class="p-5 text-center">
							<i class="fa-solid fa-user-shield text-muted mb-3" style="font-size: 3rem;"></i>
							<h5 class="fw-bold">No Administrators Found</h5>
						</div>
						<%
						} else {
						%>
						<div class="table-responsive">
							<table class="table align-middle mb-0">
								<thead class="table-light">
									<tr>
										<th class="ps-3" style="width: 50px;">#</th>
										<th>Administrator</th>
										<th>Email Address</th>
										<th>Phone</th>
										<th class="text-center" style="width: 120px;">Actions</th>
									</tr>
								</thead>
								<tbody>
									<%
									int aIdx = 1;
									for (Admin a : adminList) {
										boolean isSelf = (activeAdmin.getId() == a.getId());
									%>
									<tr>
										<td class="ps-3"><span class="text-muted small"><%=aIdx++%></span></td>
										<td>
											<div class="d-flex align-items-center gap-2">
												<div class="rounded-circle bg-light border d-flex align-items-center justify-content-center text-primary fw-bold" style="width: 36px; height: 36px;">
													<%=a.getName() != null && a.getName().length() > 0 ? a.getName().substring(0, 1).toUpperCase() : "A"%>
												</div>
												<div>
													<span class="fw-bold text-dark d-block"><%=a.getName()%></span>
													<% if (isSelf) { %>
													<span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill small" style="font-size: 0.7rem;">You (Current Session)</span>
													<% } %>
												</div>
											</div>
										</td>
										<td>
											<span class="text-primary fw-semibold small"><%=a.getEmail()%></span>
										</td>
										<td>
											<span class="text-dark small"><%=a.getPhone()%></span>
										</td>
										<td class="text-center pe-3">
											<% if (!isSelf) { %>
											<button type="button" class="btn btn-sm btn-outline-danger" data-aid="<%=a.getId()%>" onclick="confirmDeleteAdmin(this.dataset.aid, event)" title="Revoke admin access">
												<i class="fa-regular fa-trash-can"></i> Remove
											</button>
											<% } else { %>
											<button class="btn btn-sm btn-light border text-muted" disabled title="Cannot remove yourself while logged in">
												<i class="fa-solid fa-lock"></i> Active
											</button>
											<% } %>
										</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
						<%
						}
						%>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<footer class="footer mt-5">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 text-muted small">
				<div>
					<span class="fw-bold text-white">EazyDeals Admin Management</span> &bull; Logged in as: <%=activeAdmin.getEmail()%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>
