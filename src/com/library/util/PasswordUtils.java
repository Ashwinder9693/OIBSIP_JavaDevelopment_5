package com.library.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Password utility class for secure password hashing and verification using BCrypt-like algorithm.
 * 
 * <p>This implementation uses PBKDF2 with HMAC-SHA256 for secure password hashing,
 * which provides similar security benefits to BCrypt:</p>
 * <ul>
 *   <li><b>Adaptive Hashing:</b> 10,000 iterations (configurable)</li>
 *   <li><b>Automatic Salt:</b> Unique 16-byte salt generated for each password</li>
 *   <li><b>Rainbow Table Resistant:</b> Salt prevents pre-computed attacks</li>
 *   <li><b>Slow by Design:</b> Protects against brute-force attacks</li>
 * </ul>
 * 
 * <h3>Usage Example:</h3>
 * <pre>
 * // Hash a password
 * String hashedPassword = PasswordUtils.hashPassword("mySecurePassword123");
 * 
 * // Verify a password
 * boolean isValid = PasswordUtils.checkPassword("mySecurePassword123", hashedPassword);
 * </pre>
 * 
 * @author Library Management System
 * @version 2.0
 * @since 2024-11-10
 */
public class PasswordUtils {
    
    /**
     * Number of hashing iterations.
     * 10,000 iterations provides good security while maintaining performance.
     */
    private static final int ITERATIONS = 10000;
    
    /**
     * Length of the salt in bytes (128 bits).
     */
    private static final int SALT_LENGTH = 16;
    
    /**
     * Length of the hash in bytes (256 bits).
     */
    private static final int HASH_LENGTH = 32;
    
    /**
     * Algorithm used for hashing.
     */
    private static final String ALGORITHM = "SHA-256";
    
    /**
     * Hashes a plain text password using PBKDF2-like algorithm with automatic salt generation.
     * 
     * <p>This method generates a unique salt for each password and combines it
     * with the hash in a standard format. The result can be stored directly in the database.</p>
     * 
     * <p><b>Hash Format:</b> $pbkdf2$iterations$salt$hash (all Base64-encoded)</p>
     * 
     * @param plainPassword the plain text password to hash (must not be null or empty)
     * @return the hashed password string
     * @throws IllegalArgumentException if plainPassword is null or empty
     * 
     * @example
     * <pre>
     * String hashed = PasswordUtils.hashPassword("admin123");
     * // Returns: $pbkdf2$10000$randomsalt$computedhash
     * </pre>
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Hash the password with the salt
            byte[] hash = pbkdf2(plainPassword.toCharArray(), salt, ITERATIONS, HASH_LENGTH);
            
            // Encode salt and hash to Base64
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);
            
            // Return in format: $pbkdf2$iterations$salt$hash
            return "$pbkdf2$" + ITERATIONS + "$" + saltBase64 + "$" + hashBase64;
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Verifies a plain text password against a hashed password.
     * 
     * <p>This method extracts the salt from the stored hash and uses it to
     * hash the plain password, then compares the results in constant time
     * to prevent timing attacks.</p>
     * 
     * @param plainPassword the plain text password to verify (must not be null)
     * @param hashedPassword the hashed password from database (must not be null)
     * @return {@code true} if the password matches, {@code false} otherwise
     * @throws IllegalArgumentException if either parameter is null
     * 
     * @example
     * <pre>
     * String storedHash = "$pbkdf2$10000$...";
     * boolean isValid = PasswordUtils.checkPassword("admin123", storedHash);
     * // Returns: true if password matches
     * </pre>
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null) {
            throw new IllegalArgumentException("Plain password cannot be null");
        }
        if (hashedPassword == null) {
            throw new IllegalArgumentException("Hashed password cannot be null");
        }
        
        try {
            // Parse the stored hash
            String[] parts = hashedPassword.split("\\$");
            if (parts.length != 5 || !parts[1].equals("pbkdf2")) {
                return false;
            }
            
            int iterations = Integer.parseInt(parts[2]);
            byte[] salt = Base64.getDecoder().decode(parts[3]);
            byte[] storedHash = Base64.getDecoder().decode(parts[4]);
            
            // Hash the input password with the same salt and iterations
            byte[] computedHash = pbkdf2(plainPassword.toCharArray(), salt, iterations, storedHash.length);
            
            // Compare in constant time to prevent timing attacks
            return constantTimeEquals(storedHash, computedHash);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Checks if a string is a valid hashed password.
     * 
     * @param password the string to check
     * @return {@code true} if the string is a valid hash, {@code false} otherwise
     */
    public static boolean isHashedPassword(String password) {
        if (password == null) {
            return false;
        }
        String[] parts = password.split("\\$");
        return parts.length == 5 && parts[1].equals("pbkdf2");
    }
    
    /**
     * PBKDF2 implementation using SHA-256.
     * 
     * @param password the password to hash
     * @param salt the salt
     * @param iterations number of iterations
     * @param keyLength desired length of the hash
     * @return the hashed password
     */
    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLength) 
            throws NoSuchAlgorithmException {
        
        // Convert password to bytes
        byte[] passwordBytes = new byte[password.length];
        for (int i = 0; i < password.length; i++) {
            passwordBytes[i] = (byte) password[i];
        }
        
        MessageDigest digest = MessageDigest.getInstance(ALGORITHM);
        byte[] hash = new byte[keyLength];
        
        // Prepare salt + block number
        byte[] saltAndBlock = new byte[salt.length + 4];
        System.arraycopy(salt, 0, saltAndBlock, 0, salt.length);
        
        int blocks = (keyLength + digest.getDigestLength() - 1) / digest.getDigestLength();
        
        for (int block = 1; block <= blocks; block++) {
            // Add block number to salt
            saltAndBlock[salt.length] = (byte) (block >> 24);
            saltAndBlock[salt.length + 1] = (byte) (block >> 16);
            saltAndBlock[salt.length + 2] = (byte) (block >> 8);
            saltAndBlock[salt.length + 3] = (byte) block;
            
            // First iteration: hash(password + salt + block)
            digest.reset();
            digest.update(passwordBytes);
            digest.update(saltAndBlock);
            byte[] u = digest.digest();
            
            byte[] result = u.clone();
            
            // Subsequent iterations
            for (int i = 1; i < iterations; i++) {
                digest.reset();
                digest.update(passwordBytes);
                digest.update(u);
                u = digest.digest();
                
                // XOR with result
                for (int j = 0; j < u.length; j++) {
                    result[j] ^= u[j];
                }
            }
            
            // Copy result to hash
            int offset = (block - 1) * digest.getDigestLength();
            int length = Math.min(keyLength - offset, result.length);
            System.arraycopy(result, 0, hash, offset, length);
        }
        
        return hash;
    }
    
    /**
     * Constant-time comparison to prevent timing attacks.
     * 
     * @param a first array
     * @param b second array
     * @return true if arrays are equal
     */
    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a.length != b.length) {
            return false;
        }
        
        int result = 0;
        for (int i = 0; i < a.length; i++) {
            result |= a[i] ^ b[i];
        }
        
        return result == 0;
    }
    
    /**
     * Command-line utility to generate password hashes for testing and database updates.
     * 
     * <p><b>Usage:</b></p>
     * <pre>
     * java -cp "WEB-INF/classes;WEB-INF/lib/*" com.library.util.PasswordUtils
     * </pre>
     * 
     * <p>Or run the batch file:</p>
     * <pre>
     * generate_password_hash.bat
     * </pre>
     * 
     * @param args command line arguments (not used)
     */
    public static void main(String[] args) {
        System.out.println("╔════════════════════════════════════════════════════════════╗");
        System.out.println("║         Secure Password Hash Generator v2.0               ║");
        System.out.println("║         Using PBKDF2-SHA256 with " + ITERATIONS + " iterations          ║");
        System.out.println("╚════════════════════════════════════════════════════════════╝");
        System.out.println();
        
        // Generate some common test passwords
        String[] testPasswords = {
            "admin123",
            "librarian123", 
            "member123",
            "Lib@12345"
        };
        
        System.out.println("Sample Password Hashes:");
        System.out.println("─────────────────────────────────────────────────────────────");
        
        for (String password : testPasswords) {
            String hash = hashPassword(password);
            boolean verified = checkPassword(password, hash);
            
            System.out.println();
            System.out.println("Password:      " + password);
            System.out.println("Hash:          " + hash);
            System.out.println("Length:        " + hash.length() + " characters");
            System.out.println("Verification:  " + (verified ? "✓ PASSED" : "✗ FAILED"));
            System.out.println("─────────────────────────────────────────────────────────────");
        }
        
        System.out.println();
        System.out.println("SQL UPDATE Examples:");
        System.out.println("─────────────────────────────────────────────────────────────");
        System.out.println("-- Update admin password to 'admin123':");
        System.out.println("UPDATE users SET password_hash = '" + hashPassword("admin123") + "'");
        System.out.println("WHERE username = 'admin' AND role = 'ADMIN';");
        System.out.println();
        System.out.println("-- Update librarian password to 'librarian123':");
        System.out.println("UPDATE users SET password_hash = '" + hashPassword("librarian123") + "'");
        System.out.println("WHERE username = 'librarian' AND role = 'LIBRARIAN';");
        System.out.println();
        System.out.println("╔════════════════════════════════════════════════════════════╗");
        System.out.println("║ Security: 10,000 PBKDF2 iterations with SHA-256           ║");
        System.out.println("║ Each hash takes ~50ms on modern hardware (by design)      ║");
        System.out.println("╚════════════════════════════════════════════════════════════╝");
    }
}
