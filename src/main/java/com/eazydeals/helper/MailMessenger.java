package com.eazydeals.helper;

public class MailMessenger {

	public static void successfullyRegister(String userName, String userEmail) {

		// Registration Successfully
		String subject = "✅ Welcome to EazyDeals - Successful Registration!";
		String body = "<html>" + "<head>" + "<style>"
				+ "body { font-family: Arial, sans-serif; line-height: 1.8; color: #333; margin: 20px; }"
				+ ".footer { text-align: center; margin-top: 20px; }" + ".red { color: red; font-weight: bolder; }"
				+ ".grey { color: grey; }" + "</style>" + "</head>" + "<body>" + "Hey, " + userName + " !" + "<br>"
				+ "<p>Congratulations! and a warm welcome to EazyDeals! We are thrilled to have you as a part of our growing community. Thank you for choosing us for your online shopping needs.</p>"
				+ "<p>Your registration was successful, and we are excited to inform you that you are now a valued member of our platform. With EazyDeals, you'll discover a wide selection of products and exciting deals that cater to your interests and preferences.</p>"
				+ "<p>Once again, welcome aboard! We look forward to serving you and making your shopping experience delightful and rewarding.</p>"
				+ "<p>Happy shopping!</p>" + "<p>Thanks and regards,<br>EazyDeals</p>" + "<hr>" + "<div class='footer'>"
				+ "<p class='red'>* * * PLEASE DO NOT REPLY TO THIS EMAIL * * *</p>"
				+ "<p class='grey'>This is a computer-generated email and does not require any response.</p>" + "</div>"
				+ "</body>" + "</html>";

		try {
			Mail.sendMail(userEmail, subject, body);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Order Placed Successfully
	public static void successfullyOrderPlaced(String userName, String userEmail, String orderId) {
		String subject = "🛒 Order Placed - Your Product is on its way!";
		String body = "<html>" + "<head>" + "<style>"
				+ "body { font-family: Arial, sans-serif; line-height: 1.8; color: #333; margin: 20px; }"
				+ ".footer { text-align: center; margin-top: 20px; }" + ".red { color: red; font-weight: bolder; }"
				+ ".grey { color: grey; }" + ".order-id { font-size: 16px; font-weight: bold;}" + "</style>" + "</head>"
				+ "<body>" + "Hey, " + userName + " !" + "<br>"
				+ "<p>We are delighted to inform you that your order has been successfully placed and is now being processed. Thank you for choosing EazyDeals for your shopping needs!</p>"
				+ "Order ID : <span class='order-id'>" + orderId + "</span></p>"
				+ "<p>Please note that your order is currently being prepared for shipment. Our dedicated team is working diligently to ensure that your products are packed securely and dispatched at the earliest.</p>"
				+ "<p>We understand how exciting it is to receive a package, and we'll do our best to get it to you as soon as possible.</p>"
				+ "<p>Thank you for shopping with us! Your trust in <b>EazyDeals</b> means a lot to us, and we promise to provide you with an exceptional shopping experience.</p>"
				+ "<p>Thanks and regards,<br>EazyDeals</p>" + "<hr>" + "<div class='footer'>"
				+ "<p class='red'>* * * PLEASE DO NOT REPLY TO THIS EMAIL * * *</p>"
				+ "<p class='grey'>This is a computer-generated email and does not require any response.</p>" + "</div>"
				+ "</body>" + "</html>";

		try {
			Mail.sendMail(userEmail, subject, body);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Forgot Password OTP verification
	public static void sendOtp(String userEmail, int code) {
	    long currentTimeMillis = System.currentTimeMillis();
	    long expiryTimeMillis = currentTimeMillis + (5 * 60 * 1000);
	    
	    String sentTime = new java.util.Date(currentTimeMillis).toString();
	    String expiryTime = new java.util.Date(expiryTimeMillis).toString();

	    String subject = "🔑 Password Reset Request for EazyDeals Account!";
	    String body = "<html>" + "<head>" + "<style>"
	            + "body { font-family: Arial, sans-serif; line-height: 1.8; color: #333; margin: 20px; }"
	            + ".footer { text-align: center; margin-top: 20px; }" + ".grey { color: grey; }"
	            + ".red { color: red; font-weight: bolder; }" + ".code { font-size: 16px; font-weight: bold;}"
	            + "</style>" + "</head>" + "<body>" + "Hey User!<br>"
	            + "<p>Please use the below verification code to reset your password!</p>" 
	            + "<span class='code'>" + code + "</span>" 
	            + "<p>The verification code was sent on <strong>" + sentTime + "</strong> and it will valid up to <strong>" + expiryTime + "</strong>.</p>"
	            + "<p>If you did not request this change, please ignore this email.</p>"
	            + "<p>Thanks and regards,<br>EazyDeals</p>" + "<hr>" + "<div class='footer'>"
	            + "<p class='red'>* * * PLEASE DO NOT REPLY TO THIS EMAIL * * *</p>"
	            + "<p class='grey'>This is a computer-generated email and does not require any response.</p>" + "</div>"
	            + "</body>" + "</html>";

	    try {
	        Mail.sendMail(userEmail, subject, body);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}


	// Order Delivered Successfully
	public static void sendOrderDeliveredEmail(String userName, String userEmail, String orderId, String orderDate) {
		String subject = "📦 Your Order Has Been Delivered!";
		String body = "<html>" + "<head>" + "<style>"
				+ "body { font-family: Arial, sans-serif; line-height: 1.8; color: #333; margin: 20px; }"
				+ ".footer { text-align: center; margin-top: 20px; }" + ".grey { color: grey; }"
				+ ".red { color: red; font-weight: bold; }" + ".order-id { font-size: 16px; font-weight: bold;}"
				+ "</style>" + "</head>" + "<body>" + "Hey " + userName + " !" + "<br>"
				+ "<p>Congratulations!, Your order has been successfully delivered!</p>"
				+ "<p>Order ID: <span class='order-id'>" + orderId + "</span></p>"
				+ "<p>Delivery Date: <span class='order-id'>" + orderDate + "</span></p>"
				+ "<p>We hope you enjoy your purchase. If you have any questions, feel free to contact us.</p>"
				+ "<p>Thanks for shopping with us,<br>EazyDeals</p>" + "<hr>" + "<div class='footer'>"
				+ "<p class='red' style='font-weight: bolder;'>* * * PLEASE DO NOT REPLY TO THIS EMAIL * * *</p>"
				+ "<p class='grey'>This is a computer-generated email and does not require any response.</p>" + "</div>"
				+ "</body>" + "</html>";

		try {
			Mail.sendMail(userEmail, subject, body);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
