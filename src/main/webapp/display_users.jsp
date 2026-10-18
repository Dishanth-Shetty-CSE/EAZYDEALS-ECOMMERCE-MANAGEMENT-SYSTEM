<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.dao.UserDao"%>
<%@page import="com.eazydeals.entities.User"%>
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
UserDao userDao = new UserDao(ConnectionProvider.getConnection());
List<User> userList = userDao.getAllUser();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Registered Customers</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Header -->
		<div class="bg-white p-4 rounded-4 border mb-4 shadow-sm">
			<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
				<div>
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-1 small text-muted">
							<li class="breadcrumb-item"><a href="admin.jsp" class="text-decoration-none">Dashboard</a></li>
							<li class="breadcrumb-item active" aria-current="page">Customer Directory</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-dark">Registered Customers (<%=userList != null ? userList.size() : 0%>)</h3>
					<span class="text-muted small">View customer account records, emails, phone numbers, and addresses</span>
				</div>
				<a href="admin.jsp" class="btn btn-outline-secondary btn-sm px-3">
					<i class="fa-solid fa-arrow-left me-1"></i> Dashboard
				</a>
			</div>
		</div>

		<%@include file="Components/alert_message.jsp"%>

		<%
		if (userList == null || userList.isEmpty()) {
		%>
		<div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
			<img src="Images/no-results.png" alt="No Customers" class="img-fluid mb-3" style="max-width: 140px;">
			<h4 class="fw-bold text-dark mt-2">Zero Customers Registered</h4>
			<p class="text-muted small mx-auto" style="max-width: 420px;">New customer accounts will automatically appear here once users complete sign up.</p>
		</div>
		<%
		} else {
		%>
		<div class="table-responsive shadow-sm">
			<table class="table align-middle">
				<thead>
					<tr>
						<th style="width: 50px;">#</th>
						<th>Customer Name</th>
						<th>Email Address</th>
						<th>Mobile Phone</th>
						<th>Gender</th>
						<th>Registered Address</th>
						<th>Joined Date</th>
						<th class="text-center" style="width: 100px;">Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					int userIdx = 1;
					for (User u : userList) {
					%>
					<tr>
						<td><span class="text-muted small"><%=userIdx++%></span></td>
						<td>
							<div class="fw-bold text-dark"><%=u.getUserName()%></div>
						</td>
						<td>
							<span class="text-primary fw-semibold"><%=u.getUserEmail()%></span>
						</td>
						<td>
							<span class="text-dark"><%=u.getUserPhone()%></span>
						</td>
						<td>
							<span class="badge bg-light text-dark border"><%=u.getUserGender() != null ? u.getUserGender() : "N/A"%></span>
						</td>
						<td>
							<span class="small text-secondary text-truncate d-inline-block" style="max-width: 260px;" title="<%=userDao.getUserAddress(u.getUserId())%>">
								<%=userDao.getUserAddress(u.getUserId())%>
							</span>
						</td>
						<td class="small text-secondary">
							<%=u.getDateTime()%>
						</td>
						<td class="text-center">
							<button type="button" class="btn btn-sm btn-outline-danger" data-uid="<%=u.getUserId()%>" onclick="confirmDeleteUser(this.dataset.uid, event)" title="Remove user account">
								<i class="fa-regular fa-trash-can"></i> Remove
							</button>
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

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 text-muted small">
				<div>
					<span class="fw-bold text-white">EazyDeals Customer Directory</span> &bull; Logged in as: <%=activeAdmin.getEmail()%>
				</div>
				<div>
					&copy; <%= java.time.Year.now().getValue() %> EazyDeals. All rights reserved.
				</div>
			</div>
		</div>
	</footer>

</body>
</html>
