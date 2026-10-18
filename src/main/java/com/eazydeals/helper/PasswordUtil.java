package com.eazydeals.helper;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class for hashing and verifying passwords using SHA-256.
 * Supports backward-compatibility for legacy plain-text entries.
 */
public class PasswordUtil {

	/**
	 * Hashes a plain-text password using SHA-256 algorithm.
	 *
	 * @param password The plain-text password to hash
	 * @return 64-character hexadecimal hash string
	 */
	public static String hashPassword(String password) {
		if (password == null || password.trim().isEmpty()) {
			return "";
		}
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hashBytes = digest.digest(password.getBytes(StandardCharsets.UTF_8));
			StringBuilder hexString = new StringBuilder();
			for (byte b : hashBytes) {
				String hex = Integer.toHexString(0xff & b);
				if (hex.length() == 1) {
					hexString.append('0');
				}
				hexString.append(hex);
			}
			return hexString.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			// Fallback: return raw password if SHA-256 is unavailable
			return password;
		}
	}

	/**
	 * Checks if an input password matches the stored password in the database.
	 * Supports both SHA-256 hashed passwords and legacy plain-text passwords.
	 *
	 * @param plainPassword  The password provided by user during login
	 * @param storedPassword The password stored in the database
	 * @return true if matches, false otherwise
	 */
	public static boolean checkPassword(String plainPassword, String storedPassword) {
		if (plainPassword == null || storedPassword == null) {
			return false;
		}
		// 1. Check if hash matches
		String hashedInput = hashPassword(plainPassword);
		if (hashedInput.equalsIgnoreCase(storedPassword)) {
			return true;
		}
		// 2. Check plain text (legacy backward compatibility)
		return plainPassword.equals(storedPassword);
	}
}
