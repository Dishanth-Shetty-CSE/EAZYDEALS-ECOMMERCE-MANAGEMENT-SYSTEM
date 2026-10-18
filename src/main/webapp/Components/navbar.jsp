<%@page import="com.eazydeals.entities.Admin"%>
<%@page import="com.eazydeals.entities.Cart"%>
<%@page import="com.eazydeals.dao.CartDao"%>
<%@page import="com.eazydeals.entities.User"%>
<%@page import="java.util.List"%>
<%@page import="com.eazydeals.entities.Category"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page import="com.eazydeals.dao.CategoryDao"%>

<%
User user = (User) session.getAttribute("activeUser");
Admin admin = (Admin) session.getAttribute("activeAdmin");

CategoryDao catDao = new CategoryDao(ConnectionProvider.getConnection());
List<Category> categoryList = catDao.getAllCategories();
String selectedCategory = request.getParameter("category");
String currentSearch = request.getParameter("search");
if (currentSearch == null) currentSearch = "";
%>

<nav class="navbar navbar-expand-lg navbar-dark" id="mainNavbar">
	<div class="container">
		<!-- Brand Logo -->
		<a class="navbar-brand" href="index.jsp">
			<span class="brand-badge"><i class="fa-solid fa-bag-shopping"></i></span>
			<span>Eazy<span class="highlight">Deals</span></span>
		</a>

		<!-- Mobile Hamburger -->
		<button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<!-- Nav Links & Search -->
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<!-- Categories & Catalog -->
			<ul class="navbar-nav me-3 mb-2 mb-lg-0">
				<li class="nav-item">
					<a class="nav-link <%= (selectedCategory == null && currentSearch.isEmpty() && request.getRequestURI().endsWith("index.jsp")) ? "active" : "" %>" href="index.jsp">
						<i class="fa-solid fa-house"></i> Home
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link <%= "0".equals(selectedCategory) ? "active" : "" %>" href="products.jsp?category=0">
						<i class="fa-solid fa-boxes-stacked"></i> All Products
					</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
						<i class="fa-solid fa-layer-group"></i> Categories
					</a>
					<ul class="dropdown-menu">
						<li>
							<a class="dropdown-item <%= "0".equals(selectedCategory) ? "active" : "" %>" href="products.jsp?category=0">
								<i class="fa-solid fa-asterisk me-2 text-primary"></i> All Categories
							</a>
						</li>
						<li><hr class="dropdown-divider border-secondary opacity-25"></li>
						<%
						if (categoryList != null) {
							for (Category c : categoryList) {
								boolean isActiveCat = String.valueOf(c.getCategoryId()).equals(selectedCategory);
						%>
						<li>
							<a class="dropdown-item <%= isActiveCat ? "active" : "" %>" href="products.jsp?category=<%=c.getCategoryId()%>">
								<i class="fa-solid fa-chevron-right me-2 text-muted" style="font-size: 0.75rem;"></i> <%=c.getCategoryName()%>
							</a>
						</li>
						<%
							}
						}
						%>
					</ul>
				</li>
			</ul>

			<!-- Central Search Bar -->
			<div class="nav-search-container mx-auto my-2 my-lg-0">
				<form class="d-flex" action="products.jsp" method="get">
					<input class="form-control nav-search-input" type="search" name="search" 
						value="<%= currentSearch %>" placeholder="Search electronics, laptops, mobiles, furniture..." 
						aria-label="Search products" required>
					<button class="btn nav-search-btn" type="submit" aria-label="Submit search">
						<i class="fa-solid fa-magnifying-glass"></i>
					</button>
				</form>
			</div>

			<!-- User & Admin Actions -->
			<ul class="navbar-nav ms-auto align-items-lg-center">
				<%
				if (admin != null) {
				%>
				<li class="nav-item me-1">
					<button type="button" class="btn btn-sm btn-outline-light nav-link px-3" data-bs-toggle="modal"
						data-bs-target="#add-category">
						<i class="fa-solid fa-plus-circle text-primary"></i> Add Category
					</button>
				</li>
				<li class="nav-item me-1">
					<button type="button" class="btn btn-sm btn-outline-light nav-link px-3" data-bs-toggle="modal"
						data-bs-target="#add-product">
						<i class="fa-solid fa-plus-circle text-success"></i> Add Product
					</button>
				</li>
				<li class="nav-item me-1">
					<a class="nav-link active-username" href="admin.jsp">
						<i class="fa-solid fa-shield-halved"></i> <%=admin.getName()%>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link logout-btn" href="javascript:void(0);" onclick="return confirmLogout('admin');">
						<i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
					</a>
				</li>
				<%
				} else if (user != null) {
					CartDao navCartDao = new CartDao(ConnectionProvider.getConnection());
					int cartCount = navCartDao.getCartCountByUserId(user.getUserId());
				%>
				<li class="nav-item me-2 position-relative">
					<a class="nav-link position-relative px-3" href="cart.jsp">
						<i class="fa-solid fa-cart-shopping"></i> My Cart
						<% if (cartCount > 0) { %>
							<span class="cart-badge"><%=cartCount%></span>
						<% } %>
					</a>
				</li>
				<li class="nav-item me-2">
					<a class="nav-link active-username" href="profile.jsp">
						<i class="fa-solid fa-user-circle"></i> <%=user.getUserName()%>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link logout-btn" href="javascript:void(0);" onclick="return confirmLogout('user');">
						<i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
					</a>
				</li>
				<%
				} else {
				%>
				<li class="nav-item">
					<a class="nav-link" href="register.jsp">
						<i class="fa-solid fa-user-plus"></i> Register
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="login.jsp">
						<i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In
					</a>
				</li>
				<li class="nav-item ms-lg-2">
					<a class="btn btn-sm btn-outline-info text-white nav-link" href="adminlogin.jsp" style="border-radius: 8px;">
						<i class="fa-solid fa-lock"></i> Admin Portal
					</a>
				</li>
				<%
				}
				%>
			</ul>
		</div>
	</div>
</nav>

<!-- Admin: Add Category Modal -->
<div class="modal fade" id="add-category" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content rounded-4 border-0 shadow">
			<div class="modal-header bg-light border-0 py-3">
				<h5 class="modal-title fw-bold text-primary" id="addCategoryModalLabel">
					<i class="fa-solid fa-folder-plus me-2"></i> Add New Category
				</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<form id="addCategoryForm" action="AddOperationServlet" method="post" enctype="multipart/form-data" onsubmit="return handleValidateCategory(this, event)">
				<div class="modal-body p-4">
					<input type="hidden" name="operation" value="addCategory">
					<div class="mb-3">
						<label class="form-label">Category Name</label>
						<input type="text" id="categoryName" name="category_name" placeholder="e.g. Smart Watches" class="form-control">
						<div id="categoryError" class="error-message">Category name is required!</div>
					</div>
					<div class="mb-3">
						<label for="categoryImageFile" class="form-label">Category Banner / Image</label>
						<input class="form-control" type="file" name="category_img" id="categoryImageFile" accept="image/*">
						<div id="categoryImgError" class="error-message">Please select a category image file!</div>
					</div>
				</div>
				<div class="modal-footer border-0 bg-light p-3">
					<button type="button" class="btn btn-secondary px-3" data-bs-dismiss="modal">Cancel</button>
					<button type="submit" class="btn btn-primary px-4">Create Category</button>
				</div>
			</form>
		</div>
	</div>
</div>

<!-- Admin: Add Product Modal -->
<div class="modal fade" id="add-product" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered">
		<div class="modal-content rounded-4 border-0 shadow">
			<div class="modal-header bg-light border-0 py-3">
				<h5 class="modal-title fw-bold text-primary" id="addProductModalLabel">
					<i class="fa-solid fa-cart-plus me-2"></i> Add New Product
				</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<form id="addProductForm" action="AddOperationServlet" method="post" name="addProductForm" enctype="multipart/form-data" onsubmit="return handleValidateProduct(this, event)">
				<div class="modal-body p-4">
					<input type="hidden" name="operation" value="addProduct">
					<div class="mb-3">
						<label class="form-label">Product Name</label>
						<input type="text" id="productName" name="name" placeholder="e.g. Apple MacBook Pro 16 inch" class="form-control">
						<div id="productNameError" class="error-message">Product name is required!</div>
					</div>
					<div class="mb-3">
						<label class="form-label">Product Description</label>
						<textarea class="form-control" id="productDescription" name="description" rows="3" placeholder="Enter key features and specifications..."></textarea>
						<div id="productDescriptionError" class="error-message">Product description is required!</div>
					</div>
					<div class="row g-3 mb-3">
						<div class="col-md-6">
							<label class="form-label">Unit Price (&#8377;)</label>
							<input type="number" id="price" name="price" placeholder="e.g. 89999" class="form-control" min="1" step="any">
							<div id="priceError" class="error-message">Valid price is required!</div>
						</div>
						<div class="col-md-6">
							<label class="form-label">Discount Percentage (%)</label>
							<input type="number" id="discount" name="discount" placeholder="0 - 100" class="form-control" min="0" max="100" value="0">
							<div id="discountError" class="error-message">Discount must be between 0 and 100!</div>
						</div>
					</div>
					<div class="row g-3 mb-3">
						<div class="col-md-6">
							<label class="form-label">Stock Quantity</label>
							<input type="number" id="quantity" name="quantity" placeholder="e.g. 50" class="form-control" min="1" value="10">
							<div id="quantityError" class="error-message">Available stock quantity is required!</div>
						</div>
						<div class="col-md-6">
							<label class="form-label">Product Category</label>
							<select name="categoryType" id="categoryType" class="form-select">
								<option value="0">- Select Category -</option>
								<%
								if (categoryList != null) {
									for (Category c : categoryList) {
								%>
								<option value="<%=c.getCategoryId()%>"><%=c.getCategoryName()%></option>
								<%
									}
								}
								%>
							</select>
							<div id="categoryTypeError" class="error-message">Please select a product category!</div>
						</div>
					</div>
					<div class="mb-3">
						<label class="form-label">Product Image</label>
						<input type="file" name="photo" id="productPhoto" class="form-control" accept="image/*">
						<div id="productImageError" class="error-message">Please upload a product image file!</div>
					</div>
				</div>
				<div class="modal-footer border-0 bg-light p-3">
					<button type="button" class="btn btn-secondary px-3" data-bs-dismiss="modal">Cancel</button>
					<button type="submit" class="btn btn-primary px-4">Publish Product</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script type="text/javascript">
function handleValidateCategory(form, e) {
    let isValid = true;
    const catName = document.getElementById("categoryName");
    const catImg = document.getElementById("categoryImageFile");

    if (!catName.value || catName.value.trim() === "") {
        showInputError(catName, "Category name is required!");
        isValid = false;
    } else {
        clearInputError(catName);
    }

    if (!catImg.value) {
        showInputError(catImg, "Category image file is required!");
        isValid = false;
    } else {
        clearInputError(catImg);
    }

    if (!isValid) {
        e.preventDefault();
        return false;
    }

    e.preventDefault();
    confirmAction({
        title: 'Add Category',
        text: 'Are you sure you want to add this category: "' + catName.value.trim() + '"?',
        icon: 'question',
        confirmText: 'Yes, Add Category'
    }, function() {
        form.submit();
    });
    return false;
}

function handleValidateProduct(form, e) {
    let isValid = true;
    const pName = document.getElementById("productName");
    const pDesc = document.getElementById("productDescription");
    const pPrice = document.getElementById("price");
    const pDisc = document.getElementById("discount");
    const pQty = document.getElementById("quantity");
    const pCat = document.getElementById("categoryType");
    const pImg = document.getElementById("productPhoto");

    if (!pName.value || pName.value.trim() === "") {
        showInputError(pName, "Product name is required!");
        isValid = false;
    } else {
        clearInputError(pName);
    }

    if (!pDesc.value || pDesc.value.trim() === "") {
        showInputError(pDesc, "Product description is required!");
        isValid = false;
    } else {
        clearInputError(pDesc);
    }

    if (!pPrice.value || parseFloat(pPrice.value) <= 0) {
        showInputError(pPrice, "Please enter a valid price!");
        isValid = false;
    } else {
        clearInputError(pPrice);
    }

    if (pDisc.value === "" || parseFloat(pDisc.value) < 0 || parseFloat(pDisc.value) > 100) {
        showInputError(pDisc, "Discount must be between 0 and 100%!");
        isValid = false;
    } else {
        clearInputError(pDisc);
    }

    if (!pQty.value || parseInt(pQty.value) < 0) {
        showInputError(pQty, "Please enter a valid stock quantity!");
        isValid = false;
    } else {
        clearInputError(pQty);
    }

    if (!pCat.value || pCat.value === "0") {
        showInputError(pCat, "Please choose a product category!");
        isValid = false;
    } else {
        clearInputError(pCat);
    }

    if (!pImg.value) {
        showInputError(pImg, "Product image file is required!");
        isValid = false;
    } else {
        clearInputError(pImg);
    }

    if (!isValid) {
        e.preventDefault();
        return false;
    }

    e.preventDefault();
    confirmAction({
        title: 'Add New Product',
        text: 'Are you sure you want to add this product: "' + pName.value.trim() + '"?',
        icon: 'question',
        confirmText: 'Yes, Add Product'
    }, function() {
        form.submit();
    });
    return false;
}
</script>
