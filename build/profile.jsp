<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.entities.User"%>
<%@page errorPage="error_exception.jsp"%>
<%
User activeUser = (User) session.getAttribute("activeUser");
if (activeUser == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("login.jsp");
	return;
}
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Customer Dashboard</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Welcome Header -->
		<div class="bg-white p-4 rounded-4 border mb-4 shadow-sm">
			<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
				<div>
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-1 small text-muted">
							<li class="breadcrumb-item"><a href="index.jsp" class="text-decoration-none">Home</a></li>
							<li class="breadcrumb-item active" aria-current="page">Customer Profile</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Hello, <%=activeUser.getUserName()%></h3>
					<span class="text-muted small">Manage your account settings, addresses, and track placed orders</span>
				</div>
				<div>
					<span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-2 fs-6">
						<i class="fa-solid fa-award me-1"></i> Verified Member
					</span>
				</div>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<div class="row g-4">
			<!-- Sidebar Navigation -->
			<div class="col-lg-3">
				<div class="card p-3 shadow-sm border-0 mb-3 text-center">
					<div class="position-relative d-inline-block mx-auto mb-3">
						<img src="Images/user-profile.png" alt="User Profile" class="img-fluid rounded-circle border p-1" style="width: 90px; height: 90px; object-fit: cover;">
					</div>
					<h5 class="fw-bold text-dark mb-1"><%=activeUser.getUserName()%></h5>
					<p class="text-muted small mb-0"><%=activeUser.getUserEmail()%></p>
				</div>

				<div class="card p-2 shadow-sm border-0">
					<div class="list-group list-group-flush border-0">
						<button type="button" id="profile-tab-btn" class="list-group-item list-group-item-action d-flex align-items-center gap-2 py-3 px-3 active rounded-3 mb-1 fw-semibold border-0">
							<i class="fa-regular fa-user fs-5 text-primary"></i> Personal Details
						</button>
						<button type="button" id="orders-tab-btn" class="list-group-item list-group-item-action d-flex align-items-center gap-2 py-3 px-3 rounded-3 mb-1 fw-semibold border-0">
							<i class="fa-solid fa-box-open fs-5 text-secondary"></i> My Orders
						</button>
						<button type="button" class="list-group-item list-group-item-action d-flex align-items-center gap-2 py-3 px-3 rounded-3 text-danger fw-semibold border-0" onclick="confirmLogout('user')">
							<i class="fa-solid fa-arrow-right-from-bracket fs-5"></i> Log Out
						</button>
					</div>
				</div>
			</div>

			<!-- Main Content Pane -->
			<div class="col-lg-9">
				<div class="card shadow-sm border-0 bg-white">
					<div id="profile-pane">
						<%@include file="personalInfo.jsp"%>
					</div>
					<div id="orders-pane" style="display: none;">
						<%@include file="order.jsp"%>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
	document.addEventListener('DOMContentLoaded', function() {
		const profileBtn = document.getElementById('profile-tab-btn');
		const ordersBtn = document.getElementById('orders-tab-btn');
		const profilePane = document.getElementById('profile-pane');
		const ordersPane = document.getElementById('orders-pane');

		profileBtn.addEventListener('click', function() {
			profilePane.style.display = 'block';
			ordersPane.style.display = 'none';

			profileBtn.classList.add('active');
			ordersBtn.classList.remove('active');
		});

		ordersBtn.addEventListener('click', function() {
			ordersPane.style.display = 'block';
			profilePane.style.display = 'none';

			ordersBtn.classList.add('active');
			profileBtn.classList.remove('active');
		});
	});
	</script>

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<div class="row g-4">
				<div class="col-lg-4 col-md-6">
					<div class="footer-brand mb-3">
						<span class="brand-badge fs-4 p-2 me-2"><i class="fa-solid fa-bag-shopping"></i></span>
						<span class="fw-bold fs-4 text-white">Eazy<span class="highlight">Deals</span></span>
					</div>
					<p class="pe-lg-4">Your trusted shopping companion for certified quality, exceptional savings, and guaranteed prompt shipment across India.</p>
					<div class="footer-socials mt-3">
						<a href="https://facebook.com" target="_blank" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
						<a href="https://twitter.com" target="_blank" aria-label="Twitter"><i class="fa-brands fa-twitter"></i></a>
						<a href="https://instagram.com" target="_blank" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
						<a href="https://linkedin.com" target="_blank" aria-label="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
					</div>
				</div>

				<div class="col-lg-2 col-md-6 col-6">
					<h5>Categories</h5>
					<ul class="footer-links">
						<%
						if (categoryList != null) {
							int cCount = 0;
							for (Category c : categoryList) {
								if (cCount++ >= 5) break;
						%>
						<li><a href="products?category=<%=c.getCategoryId()%>"><%=c.getCategoryName()%></a></li>
						<%
							}
						}
						%>
						<li><a href="products?category=0">All Categories</a></li>
					</ul>
				</div>

				<div class="col-lg-2 col-md-6 col-6">
					<h5>Customer Care</h5>
					<ul class="footer-links">
						<li><a href="profile.jsp">My Account</a></li>
						<li><a href="cart.jsp">Shopping Cart</a></li>
						<li><a href="login.jsp">Customer Sign In</a></li>
						<li><a href="adminlogin.jsp">Admin Portal</a></li>
					</ul>
				</div>

				<div class="col-lg-4 col-md-6">
					<h5>Newsletter</h5>
					<p>Subscribe to receive promotional coupons and special sale announcements.</p>
					<form class="d-flex gap-2 mt-3" onsubmit="event.preventDefault(); Swal.fire('Subscribed!', 'Thank you for subscribing to EazyDeals updates.', 'success');">
						<input type="email" class="form-control" placeholder="Enter your email" required style="border-radius: 8px;">
						<button type="submit" class="btn btn-primary px-3 text-nowrap">Join</button>
					</form>
				</div>
			</div>

			<div class="footer-bottom">
				<p class="mb-0">&copy; <%= java.time.Year.now().getValue() %> EazyDeals E-Commerce Management System. All rights reserved.</p>
			</div>
		</div>
	</footer>

</body>
</html>
