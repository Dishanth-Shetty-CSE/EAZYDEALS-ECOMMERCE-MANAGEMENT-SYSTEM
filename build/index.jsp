<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page errorPage="error_exception.jsp"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
List<Product> productList = productDao.getAllLatestProducts();
List<Product> topDeals = productDao.getDiscountedProducts();
if (topDeals == null || topDeals.isEmpty()) {
	topDeals = productList;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>EazyDeals | Premier Online Shopping Platform</title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<!-- 1. Categories Quick Navigation Bar -->
	<section class="py-3 bg-white border-bottom">
		<div class="container">
			<div class="row row-cols-3 row-cols-sm-4 row-cols-md-6 g-2 justify-content-center">
				<%
				if (categoryList != null && !categoryList.isEmpty()) {
					for (Category c : categoryList) {
				%>
				<div class="col">
					<a href="products.jsp?category=<%=c.getCategoryId()%>" class="cat-pill-card h-100">
						<img src="Product_imgs/<%=c.getCategoryImage()%>" alt="<%=c.getCategoryName()%>" loading="lazy" onerror="this.src='Images/product.png'">
						<h6><%=c.getCategoryName()%></h6>
					</a>
				</div>
				<%
					}
				}
				%>
			</div>
		</div>
	</section>

	<!-- 2. Hero Promotional Slider -->
	<div class="container my-4">
		<div id="heroCarousel" class="carousel slide carousel-fade rounded-4 overflow-hidden shadow-sm" data-bs-ride="carousel" data-bs-interval="4500">
			<div class="carousel-indicators">
				<button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
				<button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
				<button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
			</div>
			<div class="carousel-inner">
				<div class="carousel-item active">
					<img src="Images/scrolling-img1.png" class="d-block w-100" style="max-height: 420px; object-fit: cover;" alt="Exclusive Tech Offers">
				</div>
				<div class="carousel-item">
					<img src="Images/scrolling-img2.png" class="d-block w-100" style="max-height: 420px; object-fit: cover;" alt="Big Electronics Deals">
				</div>
				<div class="carousel-item">
					<img src="Images/scrolling-img3.png" class="d-block w-100" style="max-height: 420px; object-fit: cover;" alt="Premium Gadgets & Appliances">
				</div>
			</div>
			<button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
				<span class="carousel-control-prev-icon p-3 rounded-circle bg-dark bg-opacity-50" aria-hidden="true"></span>
				<span class="visually-hidden">Previous</span>
			</button>
			<button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
				<span class="carousel-control-next-icon p-3 rounded-circle bg-dark bg-opacity-50" aria-hidden="true"></span>
				<span class="visually-hidden">Next</span>
			</button>
		</div>
	</div>

	<!-- 3. Trust Highlights -->
	<div class="container my-4">
		<div class="trust-banner">
			<div class="row g-4 text-center text-md-start">
				<div class="col-6 col-md-3">
					<div class="trust-item justify-content-center justify-content-md-start">
						<i class="fa-solid fa-truck-fast trust-icon"></i>
						<div class="trust-text">
							<h6>Free &amp; Fast Shipping</h6>
							<p>On all qualifying orders</p>
						</div>
					</div>
				</div>
				<div class="col-6 col-md-3">
					<div class="trust-item justify-content-center justify-content-md-start">
						<i class="fa-solid fa-shield-check trust-icon text-success"></i>
						<div class="trust-text">
							<h6>100% Genuine</h6>
							<p>Verified brand warranty</p>
						</div>
					</div>
				</div>
				<div class="col-6 col-md-3">
					<div class="trust-item justify-content-center justify-content-md-start">
						<i class="fa-solid fa-arrow-rotate-left trust-icon text-warning"></i>
						<div class="trust-text">
							<h6>Easy 7-Day Returns</h6>
							<p>Hassle-free exchange</p>
						</div>
					</div>
				</div>
				<div class="col-6 col-md-3">
					<div class="trust-item justify-content-center justify-content-md-start">
						<i class="fa-solid fa-headset trust-icon text-info"></i>
						<div class="trust-text">
							<h6>24/7 Dedicated Support</h6>
							<p>Live customer assistance</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 4. Hot Deals Showcase Section -->
	<section class="py-4">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
				<div>
					<h3 class="fw-bold mb-1 d-flex align-items-center gap-2">
						<i class="fa-solid fa-fire-flame-curved text-danger"></i> Hot Deals &amp; Steals
					</h3>
					<p class="text-muted small mb-0">Up to 40% discount on select top-rated essentials</p>
				</div>
				<a href="products.jsp?category=0" class="btn btn-sm btn-outline-primary px-3">
					View All Deals <i class="fa-solid fa-arrow-right ms-1"></i>
				</a>
			</div>

			<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
				<%
				int topLimit = Math.min(8, (topDeals != null ? topDeals.size() : 0));
				for (int i = 0; i < topLimit; i++) {
					Product p = topDeals.get(i);
				%>
				<div class="col">
					<div class="product-card">
						<span class="hot-badge"><i class="fa-solid fa-bolt me-1"></i> Hot Deal</span>
						<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="text-decoration-none">
							<div class="product-image-box">
								<img src="Product_imgs/<%=p.getProductImages()%>" alt="<%=p.getProductName()%>" loading="lazy" onerror="this.src='Images/product.png'">
							</div>
						</a>
						<div class="product-info-box">
							<div>
								<div class="text-muted small mb-1"><%=catDao.getCategoryName(p.getCategoryId())%></div>
								<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="text-decoration-none">
									<h5 class="product-title" title="<%=p.getProductName()%>"><%=p.getProductName()%></h5>
								</a>
								<div class="product-price-row">
									<span class="real-price">&#8377;<%=p.getProductPriceAfterDiscount()%></span>
									<span class="product-price">&#8377;<%=p.getProductPrice()%></span>
									<span class="product-discount-badge"><%=p.getProductDiscount()%>% OFF</span>
								</div>
							</div>
							<div class="d-grid gap-2 mt-3">
								<% if (user != null) { %>
								<button type="button" class="btn btn-sm btn-primary" data-uid="<%=user.getUserId()%>" data-pid="<%=p.getProductId()%>" onclick="confirmAddToCart(this.dataset.uid, this.dataset.pid, event)">
									<i class="fa-solid fa-cart-shopping me-1"></i> Add to Cart
								</button>
								<% } else { %>
								<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="btn btn-sm btn-primary">
									<i class="fa-solid fa-eye me-1"></i> View Details
								</a>
								<% } %>
							</div>
						</div>
					</div>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</section>

	<!-- 5. Latest Arrivals Section -->
	<section class="py-4 bg-white border-top border-bottom my-4">
		<div class="container">
			<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
				<div>
					<h3 class="fw-bold mb-1 d-flex align-items-center gap-2">
						<i class="fa-solid fa-sparkles text-primary"></i> Latest Arrivals
					</h3>
					<p class="text-muted small mb-0">Discover the newest products added to our collection</p>
				</div>
				<a href="products.jsp?category=0" class="btn btn-sm btn-outline-primary px-3">
					Explore All <i class="fa-solid fa-arrow-right ms-1"></i>
				</a>
			</div>

			<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
				<%
				int latestLimit = Math.min(8, (productList != null ? productList.size() : 0));
				for (int i = 0; i < latestLimit; i++) {
					Product p = productList.get(i);
				%>
				<div class="col">
					<div class="product-card">
						<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="text-decoration-none">
							<div class="product-image-box">
								<img src="Product_imgs/<%=p.getProductImages()%>" alt="<%=p.getProductName()%>" loading="lazy" onerror="this.src='Images/product.png'">
							</div>
						</a>
						<div class="product-info-box">
							<div>
								<div class="text-muted small mb-1"><%=catDao.getCategoryName(p.getCategoryId())%></div>
								<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="text-decoration-none">
									<h5 class="product-title" title="<%=p.getProductName()%>"><%=p.getProductName()%></h5>
								</a>
								<div class="product-price-row">
									<span class="real-price">&#8377;<%=p.getProductPriceAfterDiscount()%></span>
									<% if (p.getProductDiscount() > 0) { %>
									<span class="product-price">&#8377;<%=p.getProductPrice()%></span>
									<span class="product-discount-badge"><%=p.getProductDiscount()%>% OFF</span>
									<% } %>
								</div>
							</div>
							<div class="d-grid gap-2 mt-3">
								<% if (user != null) { %>
								<button type="button" class="btn btn-sm btn-outline-primary" data-uid="<%=user.getUserId()%>" data-pid="<%=p.getProductId()%>" onclick="confirmAddToCart(this.dataset.uid, this.dataset.pid, event)">
									<i class="fa-solid fa-cart-shopping me-1"></i> Add to Cart
								</button>
								<% } else { %>
								<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="btn btn-sm btn-outline-primary">
									<i class="fa-solid fa-eye me-1"></i> View Details
								</a>
								<% } %>
							</div>
						</div>
					</div>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</section>

	<%
	String orderPlaced = (String) session.getAttribute("order");
	if ("success".equals(orderPlaced)) {
	%>
	<script type="text/javascript">
		document.addEventListener('DOMContentLoaded', function() {
			Swal.fire({
				icon: 'success',
				title: 'Order Placed Successfully!',
				text: 'Thank you for shopping with EazyDeals. Your order confirmation has been processed.',
				confirmButtonColor: '#2563eb',
				confirmButtonText: 'Track Orders',
				showCancelButton: true,
				cancelButtonText: 'Continue Shopping'
			}).then((res) => {
				if (res.isConfirmed) {
					window.location.href = 'profile.jsp';
				}
			});
		});
	</script>
	<%
		session.removeAttribute("order");
	}
	%>

	<!-- 6. Luxury Footer -->
	<footer class="footer">
		<div class="container">
			<div class="row g-4">
				<div class="col-lg-4 col-md-6">
					<div class="footer-brand mb-3">
						<span class="brand-badge fs-4 p-2 me-2"><i class="fa-solid fa-bag-shopping"></i></span>
						<span class="fw-bold fs-4 text-white">Eazy<span class="highlight">Deals</span></span>
					</div>
					<p class="pe-lg-4">EazyDeals is your trusted e-commerce destination for premier electronics, laptops, home appliances, smartphones, and literature at unbeatable prices.</p>
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
						<li><a href="products?category=0">Track Orders</a></li>
						<li><a href="login.jsp">Customer Sign In</a></li>
						<li><a href="adminlogin.jsp">Admin Portal</a></li>
					</ul>
				</div>

				<div class="col-lg-4 col-md-6">
					<h5>Stay Connected</h5>
					<p>Subscribe to our newsletter for secret coupons and exclusive flash sale announcements.</p>
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
