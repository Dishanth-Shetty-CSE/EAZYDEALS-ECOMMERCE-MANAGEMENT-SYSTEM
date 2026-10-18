/**
 * EazyDeals E-Commerce Management System
 * Global JavaScript: SweetAlert2 Action Confirmations & Dynamic Real-Time Form Validations
 */

// 1. Generic SweetAlert Confirmation Helper
function confirmAction(options, callback) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: options.title || 'Are you sure?',
            text: options.text || 'Do you want to proceed with this action?',
            icon: options.icon || 'warning',
            showCancelButton: true,
            confirmButtonColor: options.confirmColor || '#2563eb',
            cancelButtonColor: '#64748b',
            confirmButtonText: options.confirmText || 'Yes, Proceed',
            cancelButtonText: options.cancelText || 'Cancel',
            reverseButtons: true,
            focusCancel: false,
            customClass: {
                popup: 'rounded-4 shadow-lg',
                confirmButton: 'btn btn-primary px-4 py-2 me-2',
                cancelButton: 'btn btn-outline-secondary px-4 py-2'
            },
            buttonsStyling: false
        }).then((result) => {
            if (result.isConfirmed && typeof callback === 'function') {
                callback();
            }
        });
    } else {
        if (confirm(options.text || options.title || 'Are you sure?')) {
            if (typeof callback === 'function') callback();
        }
    }
}

// 2. Action Confirmations (Customer & Admin)
function confirmLogout(userType) {
    confirmAction({
        title: 'Sign Out Confirmation',
        text: 'Are you sure you want to log out of your account?',
        icon: 'question',
        confirmText: 'Yes, Log Out',
        confirmColor: '#ef4444'
    }, function () {
        window.location.href = 'LogoutServlet?user=' + (userType || 'user');
    });
    return false;
}

function confirmAddToCart(userId, productId, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Add to Cart',
        text: 'Are you sure you want to add this product to your shopping cart?',
        icon: 'question',
        confirmText: 'Add to Cart',
        confirmColor: '#2563eb'
    }, function () {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = './AddToCartServlet?uid=' + userId + '&pid=' + productId;
        document.body.appendChild(form);
        form.submit();
    });
    return false;
}

function confirmBuyNow(productId, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Instant Checkout',
        text: 'Are you sure you want to proceed directly to checkout for this product?',
        icon: 'question',
        confirmText: 'Buy Now',
        confirmColor: '#059669'
    }, function () {
        window.location.href = 'checkout.jsp?from=buy&pid=' + productId;
    });
    return false;
}

function confirmCartRemoval(cartId, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Remove Item',
        text: 'Are you sure you want to remove this product from your cart?',
        icon: 'warning',
        confirmText: 'Yes, Remove',
        confirmColor: '#ef4444'
    }, function () {
        window.location.href = 'CartOperationServlet?cid=' + cartId + '&opt=3';
    });
    return false;
}

function confirmPlaceOrder(formElement, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Confirm Order Placement',
        text: 'Are you sure you want to place this order now?',
        icon: 'question',
        confirmText: 'Place Order',
        confirmColor: '#10b981'
    }, function () {
        formElement.submit();
    });
    return false;
}

function confirmDeleteProduct(pid, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Delete Product',
        text: 'Are you sure you want to delete this product? This action cannot be undone.',
        icon: 'warning',
        confirmText: 'Yes, Delete',
        confirmColor: '#ef4444'
    }, function () {
        window.location.href = 'AddOperationServlet?pid=' + pid + '&operation=deleteProduct';
    });
    return false;
}

function confirmDeleteCategory(cid, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Delete Category',
        text: 'Are you sure you want to delete this category? Associated products may be affected.',
        icon: 'warning',
        confirmText: 'Yes, Delete',
        confirmColor: '#ef4444'
    }, function () {
        window.location.href = 'AddOperationServlet?cid=' + cid + '&operation=deleteCategory';
    });
    return false;
}

function confirmDeleteUser(uid, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Remove User Account',
        text: 'Are you sure you want to permanently remove this customer account?',
        icon: 'warning',
        confirmText: 'Yes, Remove',
        confirmColor: '#ef4444'
    }, function () {
        window.location.href = 'UpdateUserServlet?operation=deleteUser&uid=' + uid;
    });
    return false;
}

function confirmDeleteAdmin(aid, event) {
    if (event) event.preventDefault();
    confirmAction({
        title: 'Remove Administrator',
        text: 'Are you sure you want to remove this administrator privilege?',
        icon: 'warning',
        confirmText: 'Yes, Remove',
        confirmColor: '#ef4444'
    }, function () {
        window.location.href = 'AdminServlet?operation=delete&id=' + aid;
    });
    return false;
}

// 3. Form Validation Helpers (Red borders and clear error text)
function showInputError(input, message) {
    if (!input) return;
    input.classList.add('error-border', 'is-invalid');
    let parent = input.parentElement;
    let errEl = parent.querySelector('.error-message, .invalid-feedback');
    if (!errEl) {
        errEl = document.createElement('div');
        errEl.className = 'error-message invalid-feedback text-danger fw-semibold mt-1';
        parent.appendChild(errEl);
    }
    errEl.textContent = message;
    errEl.style.display = 'block';
}

function clearInputError(input) {
    if (!input) return;
    input.classList.remove('error-border', 'is-invalid');
    let parent = input.parentElement;
    let errEl = parent.querySelector('.error-message, .invalid-feedback');
    if (errEl) {
        errEl.style.display = 'none';
        errEl.textContent = '';
    }
}

// 4. Real-Time Input Error Clearing
document.addEventListener('DOMContentLoaded', function () {
    // Real-time listener for inputs, selects, textareas
    document.addEventListener('input', function (e) {
        if (e.target.matches('input, select, textarea')) {
            if (e.target.value && e.target.value.trim() !== '') {
                clearInputError(e.target);
            }
        }
    });

    document.addEventListener('change', function (e) {
        if (e.target.matches('input, select, textarea')) {
            if (e.target.value && e.target.value.trim() !== '') {
                clearInputError(e.target);
            }
        }
    });

    // Auto-scroll navbar glass effect
    window.addEventListener('scroll', function () {
        const navbar = document.querySelector('.navbar');
        if (navbar) {
            if (window.scrollY > 15) {
                navbar.classList.add('navbar-scrolled', 'shadow-sm');
            } else {
                navbar.classList.remove('navbar-scrolled', 'shadow-sm');
            }
        }
    });
});
