<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.dao.CategoryDao"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page errorPage="error_exception.jsp"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
int productId = 0;
try {
	productId = Integer.parseInt(request.getParameter("pid"));
} catch (Exception e) {
	response.sendRedirect("products?category=0");
	return;
}

ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
Product product = productDao.getProductsByProductId(productId);
if (product == null || product.getProductName() == null) {
	response.sendRedirect("products?category=0");
	return;
}

CategoryDao categoryDao = new CategoryDao(ConnectionProvider.getConnection());
String categoryName = categoryDao.getCategoryName(product.getCategoryId());

String productDescription = product.getProductDescription();
if (productDescription == null) productDescription = "";
String[] descriptionSentences = productDescription.split("\\.\\s*");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | <%=product.getProductName()%></title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Breadcrumbs -->
		<nav aria-label="breadcrumb" class="mb-4">
			<ol class="breadcrumb small">
				<li class="breadcrumb-item"><a href="index.jsp" class="text-decoration-none">Home</a></li>
				<li class="breadcrumb-item"><a href="products?category=<%=product.getCategoryId()%>" class="text-decoration-none"><%=categoryName%></a></li>
				<li class="breadcrumb-item active text-truncate" style="max-width: 320px;" aria-current="page"><%=product.getProductName()%></li>
			</ol>
		</nav>

		<%@include file="Components/alert_message.jsp"%>

		<div class="bg-white rounded-4 border p-4 p-lg-5 shadow-sm">
			<div class="row g-4 g-lg-5">
				<!-- Left Column: Product Showcase -->
				<div class="col-lg-5">
					<div class="p-4 rounded-4 bg-light border d-flex align-items-center justify-content-center" style="min-height: 420px;">
						<img src="Product_imgs/<%=product.getProductImages()%>" alt="<%=product.getProductName()%>" class="img-fluid" style="max-height: 380px; object-fit: contain;" onerror="this.src='Images/product.png'">
					</div>
				</div>

				<!-- Right Column: Details & Actions -->
				<div class="col-lg-7 d-flex flex-column justify-content-between">
					<div>
						<div class="d-flex align-items-center gap-2 mb-2">
							<span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-1">
								<%=categoryName%>
							</span>
							<% if (product.getProductQunatity() > 0) { %>
							<span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-1">
								<i class="fa-solid fa-circle-check me-1"></i> In Stock (<%=product.getProductQunatity()%> units)
							</span>
							<% } else { %>
							<span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-3 py-1">
								<i class="fa-solid fa-circle-xmark me-1"></i> Out of Stock
							</span>
							<% } %>
						</div>

						<h2 class="fw-bold mb-3 text-dark"><%=product.getProductName()%></h2>

						<!-- Pricing Block -->
						<div class="p-3 rounded-3 bg-light border mb-4 d-flex align-items-baseline gap-3 flex-wrap">
							<span class="fs-2 fw-bold text-dark">&#8377;<%=product.getProductPriceAfterDiscount()%></span>
							<% if (product.getProductDiscount() > 0) { %>
							<span class="text-muted text-decoration-line-through fs-5">&#8377;<%=product.getProductPrice()%></span>
							<span class="badge bg-success text-white px-2 py-1 fs-6">Save <%=product.getProductDiscount()%>%</span>
							<% } %>
							<span class="text-muted small ms-auto">Inclusive of all taxes</span>
						</div>

						<!-- Description Features -->
						<div class="mb-4">
							<h6 class="fw-bold text-uppercase text-muted small mb-3 letter-spacing-1">Key Specifications &amp; Features</h6>
							<ul class="list-unstyled mb-0">
								<%
								for (String sentence : descriptionSentences) {
									if (!sentence.trim().isEmpty()) {
								%>
								<li class="d-flex align-items-start gap-2 mb-2 text-secondary">
									<i class="fa-solid fa-circle-check text-success mt-1"></i>
									<span><%=sentence.trim()%>.</span>
								</li>
								<%
									}
								}
								%>
							</ul>
						</div>

						<!-- Trust Badges -->
						<div class="row g-2 border-top border-bottom py-3 mb-4 text-center">
							<div class="col-4">
								<div class="small text-muted"><i class="fa-solid fa-truck-fast fs-5 d-block text-primary mb-1"></i> Free Shipping</div>
							</div>
							<div class="col-4">
								<div class="small text-muted"><i class="fa-solid fa-money-bill-transfer fs-5 d-block text-success mb-1"></i> COD Available</div>
							</div>
							<div class="col-4">
								<div class="small text-muted"><i class="fa-solid fa-shield-halved fs-5 d-block text-warning mb-1"></i> Brand Warranty</div>
							</div>
						</div>
					</div>

					<!-- Action Buttons -->
					<div class="mt-3">
						<% if (product.getProductQunatity() > 0) { %>
							<div class="d-flex gap-3 flex-wrap">
								<% if (user != null) { %>
								<button type="button" class="btn btn-primary btn-lg flex-grow-1 py-3" data-uid="<%=user.getUserId()%>" data-pid="<%=product.getProductId()%>" onclick="confirmAddToCart(this.dataset.uid, this.dataset.pid, event)">
									<i class="fa-solid fa-cart-shopping me-2"></i> Add to Cart
								</button>
								<button type="button" class="btn btn-success btn-lg flex-grow-1 py-3" data-pid="<%=product.getProductId()%>" onclick="confirmBuyNow(this.dataset.pid, event)">
									<i class="fa-solid fa-bolt me-2"></i> Buy Now
								</button>
								<% } else { %>
								<button type="button" class="btn btn-primary btn-lg flex-grow-1 py-3" data-bs-toggle="modal" data-bs-target="#loginPromptModal">
									<i class="fa-solid fa-cart-shopping me-2"></i> Add to Cart
								</button>
								<button type="button" class="btn btn-success btn-lg flex-grow-1 py-3" data-bs-toggle="modal" data-bs-target="#loginPromptModal">
									<i class="fa-solid fa-bolt me-2"></i> Buy Now
								</button>
								<% } %>
							</div>
						<% } else { %>
							<button class="btn btn-secondary btn-lg w-100 py-3 disabled" disabled>
								<i class="fa-solid fa-ban me-2"></i> Product Currently Unavailable
							</button>
						<% } %>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Modal: Login Required Prompt -->
	<div class="modal fade" id="loginPromptModal" tabindex="-1" aria-labelledby="loginPromptModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content rounded-4 border-0 shadow">
				<div class="modal-header bg-light border-0 py-3">
					<h5 class="modal-title fw-bold text-primary" id="loginPromptModalLabel">
						<i class="fa-solid fa-lock me-2"></i> Sign In Required
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body p-4 text-center">
					<div class="mb-3">
						<span class="brand-badge fs-2 p-3"><i class="fa-solid fa-user-lock"></i></span>
					</div>
					<h5 class="fw-bold">Sign In to Continue</h5>
					<p class="text-muted small">Please sign in to your EazyDeals customer account to add items to your cart or proceed to checkout.</p>
					<div class="d-grid gap-2 mt-4">
						<a href="login.jsp" class="btn btn-primary py-2">Sign In to My Account</a>
						<a href="register.jsp" class="btn btn-outline-secondary py-2">Create New Account</a>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<footer class="footer">
		<div class="container">
			<div class="row g-4">
				<div class="col-lg-4 col-md-6">
					<div class="footer-brand mb-3">
						<span class="brand-badge fs-4 p-2 me-2"><i class="fa-solid fa-bag-shopping"></i></span>
						<span class="fw-bold fs-4 text-white">Eazy<span class="highlight">Deals</span></span>
					</div>
					<p class="pe-lg-4">Delivering premium shopping experiences with certified authentic quality, secure payment gateways, and lightning-fast customer support.</p>
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
					<h5>Account &amp; Orders</h5>
					<ul class="footer-links">
						<li><a href="profile.jsp">My Profile</a></li>
						<li><a href="cart.jsp">My Shopping Cart</a></li>
						<li><a href="login.jsp">Customer Sign In</a></li>
						<li><a href="register.jsp">Create Account</a></li>
					</ul>
				</div>

				<div class="col-lg-4 col-md-6">
					<h5>Newsletter</h5>
					<p>Subscribe to our newsletter for exclusive flash sale announcements.</p>
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
