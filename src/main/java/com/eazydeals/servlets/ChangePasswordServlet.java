package com.eazydeals.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Random;
import com.eazydeals.dao.UserDao;
import com.eazydeals.entities.Message;
import com.eazydeals.helper.ConnectionProvider;
import com.eazydeals.helper.MailMessenger;

public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final long OTP_VALIDITY_DURATION = 5 * 60 * 1000;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String referrer = request.getHeader("referer");
        UserDao userDao = new UserDao(ConnectionProvider.getConnection());
        HttpSession session = request.getSession();

        if (referrer.contains("forgot_password")) {
            String email = request.getParameter("email").trim();
            List<String> list = userDao.getAllEmail();
            if (list.contains(email)) {
                Random rand = new Random();
                int max = 999999, min = 100000;
                int otp = rand.nextInt(max - min + 1) + min;
                long otpGeneratedTime = System.currentTimeMillis();
                session.setAttribute("otp", otp);
                session.setAttribute("otpGeneratedTime", otpGeneratedTime);
                session.setAttribute("email", email);
                MailMessenger.sendOtp(email, otp);

                Message message = new Message("Password reset code sent to " + email + "!", "success", "alert-success");
                session.setAttribute("message", message);
                response.sendRedirect("otp_code.jsp");
            } else {
                Message message = new Message("Email not found! Try with another email!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("forgot_password.jsp");
                return;
            }
        } else if (referrer.contains("otp_code")) {
            int code = Integer.parseInt(request.getParameter("code"));
            int otp = (int) session.getAttribute("otp");
            long otpGeneratedTime = (long) session.getAttribute("otpGeneratedTime");
            long currentTime = System.currentTimeMillis();

            if (currentTime - otpGeneratedTime <= OTP_VALIDITY_DURATION) {
                if (code == otp) {
                    session.removeAttribute("otp");
                    session.removeAttribute("otpGeneratedTime");
                    response.sendRedirect("change_password.jsp");
                } else {
                    Message message = new Message("Invalid verification code entered!", "error", "alert-danger");
                    session.setAttribute("message", message);
                    response.sendRedirect("otp_code.jsp");
                    return;
                }
            } else {
                Message message = new Message("OTP has expired! Please request a new one.", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("otp_code.jsp");
                return;
            }
        } else if (referrer.contains("change_password")) {
            String password = request.getParameter("password");
            String email = (String) session.getAttribute("email");
            userDao.updateUserPasswordByEmail(password, email);
            session.removeAttribute("email");

            Message message = new Message("Password updated successfully!", "success", "alert-success");
            session.setAttribute("message", message);
            response.sendRedirect("login.jsp");
        }
    }
}
