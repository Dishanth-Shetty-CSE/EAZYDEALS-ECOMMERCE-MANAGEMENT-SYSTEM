<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.entities.Category"%>
<%@page import="com.eazydeals.dao.CategoryDao"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page import="java.util.List"%>

<%
List<Product> prodList = (List<Product>) request.getAttribute("prodList");
String pageTitleMessage = (String) request.getAttribute("message");

ProductDao pDao = new ProductDao(ConnectionProvider.getConnection());
CategoryDao cDao = new CategoryDao(ConnectionProvider.getConnection());

String catParam = request.getParameter("category");
String searchParam = request.getParameter("search");

// Fallback if accessed directly without servlet forward
if (prodList == null) {
	if (searchParam != null && !searchParam.trim().isEmpty()) {
		prodList = pDao.getAllProductsBySearchKey(searchParam.trim());
		pageTitleMessage = "Showing results for \"" + searchParam.trim() + "\"";
	} else if (catParam != null && !catParam.trim().equals("0")) {
		try {
			int cid = Integer.parseInt(catParam.trim());
			prodList = pDao.getAllProductsByCategoryId(cid);
			pageTitleMessage = "Showing results for \"" + cDao.getCategoryName(cid) + "\"";
		} catch (Exception e) {
			prodList = pDao.getAllProducts();
			pageTitleMessage = "All Products";
		}
	} else {
		prodList = pDao.getAllProducts();
		pageTitleMessage = "All Products";
	}
}

if (pageTitleMessage == null || pageTitleMessage.trim().isEmpty()) {
	pageTitleMessage = "Product Catalog";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>EazyDeals | <%= pageTitleMessage %></title>
<link rel="icon" href="Images/favicon-img.png" type="image/x-icon">
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>

	<%@include file="Components/navbar.jsp"%>

	<div class="container py-4">
		<!-- Header & Breadcrumb -->
		<div class="bg-white p-4 rounded-4 border mb-4 shadow-sm">
			<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
				<div>
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-1 small text-muted">
							<li class="breadcrumb-item"><a href="index.jsp" class="text-decoration-none">Home</a></li>
							<li class="breadcrumb-item active" aria-current="page">Catalog</li>
						</ol>
					</nav>
					<h3 class="fw-bold mb-0 text-primary"><%= pageTitleMessage %></h3>
				</div>
				<div>
					<span class="badge bg-light text-dark border px-3 py-2 fs-6 fw-semibold">
						<i class="fa-solid fa-boxes-stacked me-1 text-primary"></i> <%= (prodList != null ? prodList.size() : 0) %> Items Available
					</span>
				</div>
			</div>
		</div>

		<!-- Category Filter Pills -->
		<div class="d-flex gap-2 mb-4 overflow-auto pb-2 flex-nowrap flex-md-wrap">
			<a href="products.jsp?category=0" class="btn btn-sm <%= (catParam == null || "0".equals(catParam)) ? "btn-primary" : "btn-light border" %> rounded-pill px-3 py-2 fw-semibold text-nowrap">
				<i class="fa-solid fa-asterisk me-1"></i> All Products
			</a>
			<%
			if (categoryList != null) {
				for (Category catItem : categoryList) {
					boolean isSel = String.valueOf(catItem.getCategoryId()).equals(catParam);
			%>
			<a href="products.jsp?category=<%=catItem.getCategoryId()%>" class="btn btn-sm <%= isSel ? "btn-primary" : "btn-light border" %> rounded-pill px-3 py-2 fw-semibold text-nowrap d-inline-flex align-items-center gap-1">
				<img src="Product_imgs/<%=catItem.getCategoryImage()%>" style="width: 20px; height: 20px; object-fit: contain;" class="rounded-circle" alt="" onerror="this.style.display='none'">
				<span><%=catItem.getCategoryName()%></span>
			</a>
			<%
				}
			}
			%>
		</div>

		<!-- Product Grid -->
		<%
		if (prodList != null && !prodList.isEmpty()) {
		%>
		<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
			<%
			for (Product p : prodList) {
				String catName = cDao.getCategoryName(p.getCategoryId());
			%>
			<div class="col">
				<div class="product-card">
					<% if (p.getProductDiscount() >= 25) { %>
					<span class="hot-badge"><i class="fa-solid fa-fire me-1"></i> <%=p.getProductDiscount()%>% OFF</span>
					<% } %>

					<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="text-decoration-none">
						<div class="product-image-box">
							<img src="Product_imgs/<%=p.getProductImages()%>" alt="<%=p.getProductName()%>" loading="lazy" onerror="this.src='Images/product.png'">
						</div>
					</a>

					<div class="product-info-box">
						<div>
							<div class="text-muted small mb-1"><%=catName%></div>
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

						<div class="d-flex gap-2 mt-3">
							<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="btn btn-sm btn-outline-secondary flex-grow-1">
								<i class="fa-solid fa-circle-info me-1"></i> Details
							</a>
							<% if (user != null) { %>
							<button type="button" class="btn btn-sm btn-primary flex-grow-1" data-uid="<%=user.getUserId()%>" data-pid="<%=p.getProductId()%>" onclick="confirmAddToCart(this.dataset.uid, this.dataset.pid, event)">
								<i class="fa-solid fa-cart-shopping me-1"></i> Add
							</button>
							<% } else { %>
							<a href="viewProduct.jsp?pid=<%=p.getProductId()%>" class="btn btn-sm btn-primary flex-grow-1">
								<i class="fa-solid fa-cart-shopping me-1"></i> Buy
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
		<%
		} else {
		%>
		<!-- Empty State -->
		<div class="bg-white p-5 rounded-4 border text-center shadow-sm my-4">
			<img src="Images/no-results.png" alt="No Products Found" class="img-fluid mb-3" style="max-width: 140px;">
			<h4 class="fw-bold text-dark mt-2">No Matching Products Found</h4>
			<p class="text-muted mx-auto" style="max-width: 480px;">We couldn't find any products matching your selection. Try clearing your filters or searching with a different keyword.</p>
			<div class="mt-4">
				<a href="products?category=0" class="btn btn-primary px-4 me-2">Browse All Products</a>
				<a href="index.jsp" class="btn btn-outline-secondary px-4">Return Home</a>
			</div>
		</div>
		<%
		}
		%>
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
					<p class="pe-lg-4">Explore thousands of verified products across laptops, mobiles, fashion, home essentials, and entertainment with best market discounts.</p>
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
