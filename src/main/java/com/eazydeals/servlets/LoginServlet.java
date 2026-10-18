package com.eazydeals.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.eazydeals.dao.AdminDao;
import com.eazydeals.dao.UserDao;
import com.eazydeals.entities.Admin;
import com.eazydeals.entities.Message;
import com.eazydeals.entities.User;
import com.eazydeals.helper.ConnectionProvider;

public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Determine if the login is for 'user' or 'admin'
		String login = request.getParameter("login").trim();
		HttpSession session = request.getSession();  // Common session setup for both user and admin

		if (login.equals("user")) {
			try {
				// Get user credentials
				String userEmail = request.getParameter("user_email");
				String userPassword = request.getParameter("user_password");

				// Use UserDao to fetch user by email and password
				UserDao userDao = new UserDao(ConnectionProvider.getConnection());
				User user = userDao.getUserByEmailPassword(userEmail, userPassword);

				// Check if user exists
				if (user != null) {
					// Store user object in session
					session.setAttribute("activeUser", user);
					response.sendRedirect("index.jsp");
				} else {
					// Invalid credentials
					Message message = new Message("Invalid details! Try again!!", "error", "alert-danger");
					session.setAttribute("message", message);
					response.sendRedirect("login.jsp");
				}
			} catch (Exception e) {
				e.printStackTrace();
				// Error handling and redirect in case of exceptions
				Message message = new Message("An error occurred during login! Please try again later.", "error", "alert-danger");
				session.setAttribute("message", message);
				response.sendRedirect("login.jsp");
			}

		} else if (login.equals("admin")) {
			try {
				// Get admin credentials
				String adminEmail = request.getParameter("email");
				String adminPassword = request.getParameter("password");

				// Use AdminDao to fetch admin by email and password
				AdminDao adminDao = new AdminDao(ConnectionProvider.getConnection());
				Admin admin = adminDao.getAdminByEmailPassword(adminEmail, adminPassword);

				// Check if admin exists
				if (admin != null) {
					// Store admin object in session
					session.setAttribute("activeAdmin", admin);
					response.sendRedirect("admin.jsp");
				} else {
					// Invalid credentials for admin
					Message message = new Message("Invalid details! Try again!!", "error", "alert-danger");
					session.setAttribute("message", message);
					response.sendRedirect("adminlogin.jsp");
				}
			} catch (Exception e) {
				e.printStackTrace();
				// Error handling for admin login
				Message message = new Message("An error occurred during admin login! Please try again later.", "error", "alert-danger");
				session.setAttribute("message", message);
				response.sendRedirect("adminlogin.jsp");
			}
		}
	}
}
