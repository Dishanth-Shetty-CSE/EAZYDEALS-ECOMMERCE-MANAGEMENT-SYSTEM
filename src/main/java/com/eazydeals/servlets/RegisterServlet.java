package com.eazydeals.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.eazydeals.dao.UserDao;
import com.eazydeals.entities.Message;
import com.eazydeals.entities.User;
import com.eazydeals.helper.ConnectionProvider;
import com.eazydeals.helper.MailMessenger;

public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Connection conn = null;

		try {
			// Get user input from request
			String userName = request.getParameter("user_name");
			String userEmail = request.getParameter("user_email");
			String userPassword = request.getParameter("user_password");
			String userPhone = request.getParameter("user_mobile_no");
			String userGender = request.getParameter("gender");
			String userAddress = request.getParameter("user_address");
			String userCity = request.getParameter("city");
			String userPincode = request.getParameter("pincode");
			String userState = request.getParameter("state");

			// Establish a connection
			conn = ConnectionProvider.getConnection();

			// Check if the email already exists
			if (emailExists(userEmail, conn)) {
				HttpSession session = request.getSession();
				Message message = new Message("Email already exists! Please use another email.", "error", "alert-danger");
				session.setAttribute("message", message);
				response.sendRedirect("register.jsp");
				return;
			}

			// Create a new User object
			User user = new User(userName, userEmail, userPassword, userPhone, userGender, userAddress, userCity,
					userPincode, userState);

			// Save the user using UserDao
			UserDao userDao = new UserDao(conn); // Pass the connection to UserDao
			boolean flag = userDao.saveUser(user);

			// Set up the session and redirect to appropriate page
			HttpSession session = request.getSession();
			Message message;
			if (flag) {
				message = new Message("Registration Successful! You can now log in.", "success", "alert-success");
				MailMessenger.successfullyRegister(userName, userEmail);
				session.setAttribute("message", message);
				response.sendRedirect("login.jsp");
			} else {
				message = new Message("Something went wrong! Try again!", "error", "alert-danger");
				session.setAttribute("message", message);
				response.sendRedirect("register.jsp");
			}

		} catch (Exception e) {
			e.printStackTrace();
			HttpSession session = request.getSession();
			Message message = new Message("An error occurred! Please try again later.", "error", "alert-danger");
			session.setAttribute("message", message);
			response.sendRedirect("register.jsp");
		}
	}

	// Method to check if the email already exists
	private boolean emailExists(String email, Connection conn) {
		boolean exists = false;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT email FROM user WHERE email = ?";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				exists = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return exists;
	}
}
