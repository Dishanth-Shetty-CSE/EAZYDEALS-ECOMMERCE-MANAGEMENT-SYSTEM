package com.eazydeals.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;
import com.eazydeals.entities.Message;
import com.eazydeals.helper.MailMessenger;

public class ResendOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final long OTP_VALIDITY_DURATION = 5 * 60 * 1000;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("email") : null;

        if (email == null) {
            Message message = new Message("No email found in session or session expired!", "error", "alert-danger");
            session.setAttribute("message", message);
            response.sendRedirect("otp_code.jsp");
            return;
        }

        Long otpGeneratedTime = (Long) session.getAttribute("otpGeneratedTime"); 
        long currentTime = System.currentTimeMillis();

        if (otpGeneratedTime == null || (currentTime - otpGeneratedTime > OTP_VALIDITY_DURATION)) {
            Random rand = new Random();
            int max = 999999, min = 100000;
            int otp = rand.nextInt(max - min + 1) + min;
            session.setAttribute("otp", otp); 
            session.setAttribute("otpGeneratedTime", currentTime);
            MailMessenger.sendOtp(email, otp); 

            Message message = new Message("Verification code resent successfully!", "success", "alert-success");
            session.setAttribute("message", message);
        } else {
            Message message = new Message("Please wait before requesting a new OTP.", "warning", "alert-warning");
            session.setAttribute("message", message);
        }

        response.sendRedirect("otp_code.jsp");
    }
}
