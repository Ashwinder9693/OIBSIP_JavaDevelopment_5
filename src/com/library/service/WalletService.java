package com.library.service;

import com.library.dao.WalletDAO;
import com.library.dao.UserDAO;
import com.library.entity.WalletTransaction;
import com.library.entity.User;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class WalletService {
    private WalletDAO walletDAO;
    private UserDAO userDAO;
    
    public WalletService() {
        this.walletDAO = new WalletDAO();
        this.userDAO = new UserDAO();
    }
    
    /**
     * User initiates a wallet top-up (pending admin approval)
     */
    public WalletTransaction requestTopup(int userId, BigDecimal amount, String paymentMethod, String paymentReference) {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return null;
        }
        
        // Get current balances
        BigDecimal currentBalance = user.getWalletBalance();
        BigDecimal currentPending = user.getWalletPendingBalance();
        
        // Create pending transaction
        WalletTransaction transaction = new WalletTransaction();
        transaction.setUserId(userId);
        transaction.setTransactionType(WalletTransaction.TransactionType.TOPUP);
        transaction.setAmount(amount);
        transaction.setBalanceBefore(currentBalance);
        transaction.setBalanceAfter(currentBalance); // Won't change until approved
        transaction.setStatus(WalletTransaction.TransactionStatus.PENDING);
        transaction.setPaymentMethod(paymentMethod);
        transaction.setPaymentReference(paymentReference);
        transaction.setDescription("Wallet top-up request - Pending approval");
        transaction.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        
        WalletTransaction created = walletDAO.createTransaction(transaction);
        
        if (created != null) {
            // Update pending balance
            BigDecimal newPending = currentPending.add(amount);
            walletDAO.updateUserPendingBalance(userId, newPending);
        }
        
        return created;
    }
    
    /**
     * Admin approves a pending top-up
     */
    public boolean approveTopup(int transactionId, int approvedBy) {
        WalletTransaction transaction = walletDAO.getTransactionById(transactionId);
        if (transaction == null || transaction.getStatus() != WalletTransaction.TransactionStatus.PENDING) {
            return false;
        }
        
        User user = userDAO.getUserById(transaction.getUserId());
        if (user == null) {
            return false;
        }
        
        // Update balances
        BigDecimal currentBalance = user.getWalletBalance();
        BigDecimal currentPending = user.getWalletPendingBalance();
        BigDecimal newBalance = currentBalance.add(transaction.getAmount());
        BigDecimal newPending = currentPending.subtract(transaction.getAmount());
        
        // Update transaction
        if (walletDAO.approveTransaction(transactionId, approvedBy)) {
            // Update user balances
            walletDAO.updateUserWalletBalance(transaction.getUserId(), newBalance);
            walletDAO.updateUserPendingBalance(transaction.getUserId(), newPending);
            
            // Create a completed transaction record
            WalletTransaction completedTx = new WalletTransaction();
            completedTx.setUserId(transaction.getUserId());
            completedTx.setTransactionType(WalletTransaction.TransactionType.TOPUP);
            completedTx.setAmount(transaction.getAmount());
            completedTx.setBalanceBefore(currentBalance);
            completedTx.setBalanceAfter(newBalance);
            completedTx.setStatus(WalletTransaction.TransactionStatus.COMPLETED);
            completedTx.setPaymentMethod(transaction.getPaymentMethod());
            completedTx.setPaymentReference(transaction.getPaymentReference());
            completedTx.setDescription("Wallet top-up approved by admin");
            completedTx.setApprovedBy(approvedBy);
            completedTx.setApprovedAt(new Timestamp(System.currentTimeMillis()));
            walletDAO.createTransaction(completedTx);
            
            return true;
        }
        
        return false;
    }
    
    /**
     * Admin rejects a pending top-up
     */
    public boolean rejectTopup(int transactionId, int rejectedBy) {
        WalletTransaction transaction = walletDAO.getTransactionById(transactionId);
        if (transaction == null || transaction.getStatus() != WalletTransaction.TransactionStatus.PENDING) {
            return false;
        }
        
        User user = userDAO.getUserById(transaction.getUserId());
        if (user == null) {
            return false;
        }
        
        // Reject transaction and remove from pending balance
        if (walletDAO.rejectTransaction(transactionId, rejectedBy)) {
            BigDecimal currentPending = user.getWalletPendingBalance();
            BigDecimal newPending = currentPending.subtract(transaction.getAmount());
            walletDAO.updateUserPendingBalance(transaction.getUserId(), newPending);
            return true;
        }
        
        return false;
    }
    
    /**
     * Admin directly credits money to user's wallet
     */
    public WalletTransaction adminCreditWallet(int userId, BigDecimal amount, int adminId, String description) {
        User user = userDAO.getUserById(userId);
        if (user == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return null;
        }
        
        BigDecimal currentBalance = user.getWalletBalance();
        BigDecimal newBalance = currentBalance.add(amount);
        
        // Create transaction
        WalletTransaction transaction = new WalletTransaction();
        transaction.setUserId(userId);
        transaction.setTransactionType(WalletTransaction.TransactionType.ADMIN_CREDIT);
        transaction.setAmount(amount);
        transaction.setBalanceBefore(currentBalance);
        transaction.setBalanceAfter(newBalance);
        transaction.setStatus(WalletTransaction.TransactionStatus.COMPLETED);
        transaction.setDescription(description != null ? description : "Admin credit");
        transaction.setApprovedBy(adminId);
        transaction.setApprovedAt(new Timestamp(System.currentTimeMillis()));
        transaction.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        
        WalletTransaction created = walletDAO.createTransaction(transaction);
        if (created != null) {
            walletDAO.updateUserWalletBalance(userId, newBalance);
        }
        
        return created;
    }
    
    /**
     * Deduct money from wallet for reservation payment
     */
    public WalletTransaction deductFromWallet(int userId, BigDecimal amount, int reservationId, String description) {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return null;
        }
        
        BigDecimal currentBalance = user.getWalletBalance();
        
        // Check if sufficient balance
        if (currentBalance.compareTo(amount) < 0) {
            return null;
        }
        
        BigDecimal newBalance = currentBalance.subtract(amount);
        
        // Create transaction
        WalletTransaction transaction = new WalletTransaction();
        transaction.setUserId(userId);
        transaction.setTransactionType(WalletTransaction.TransactionType.DEBIT);
        transaction.setAmount(amount);
        transaction.setBalanceBefore(currentBalance);
        transaction.setBalanceAfter(newBalance);
        transaction.setStatus(WalletTransaction.TransactionStatus.COMPLETED);
        transaction.setRelatedReservationId(reservationId);
        transaction.setDescription(description != null ? description : "Reservation payment");
        transaction.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        
        WalletTransaction created = walletDAO.createTransaction(transaction);
        if (created != null) {
            walletDAO.updateUserWalletBalance(userId, newBalance);
        }
        
        return created;
    }
    
    /**
     * Refund money to wallet (e.g., cancelled reservation)
     */
    public WalletTransaction refundToWallet(int userId, BigDecimal amount, int reservationId, String description) {
        User user = userDAO.getUserById(userId);
        if (user == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return null;
        }
        
        BigDecimal currentBalance = user.getWalletBalance();
        BigDecimal newBalance = currentBalance.add(amount);
        
        // Create transaction
        WalletTransaction transaction = new WalletTransaction();
        transaction.setUserId(userId);
        transaction.setTransactionType(WalletTransaction.TransactionType.REFUND);
        transaction.setAmount(amount);
        transaction.setBalanceBefore(currentBalance);
        transaction.setBalanceAfter(newBalance);
        transaction.setStatus(WalletTransaction.TransactionStatus.COMPLETED);
        transaction.setRelatedReservationId(reservationId);
        transaction.setDescription(description != null ? description : "Reservation refund");
        transaction.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        
        WalletTransaction created = walletDAO.createTransaction(transaction);
        if (created != null) {
            walletDAO.updateUserWalletBalance(userId, newBalance);
        }
        
        return created;
    }
    
    /**
     * Get user's wallet balance
     */
    public BigDecimal getUserBalance(int userId) {
        return walletDAO.getUserWalletBalance(userId);
    }
    
    /**
     * Get all pending top-up requests (for admin)
     */
    public List<WalletTransaction> getPendingTopups() {
        return walletDAO.getPendingTopups();
    }
    
    /**
     * Get user's transaction history
     */
    public List<WalletTransaction> getUserTransactions(int userId) {
        return walletDAO.getUserTransactions(userId);
    }
    
    /**
     * Check if user has sufficient balance
     */
    public boolean hasSufficientBalance(int userId, BigDecimal requiredAmount) {
        BigDecimal balance = getUserBalance(userId);
        return balance.compareTo(requiredAmount) >= 0;
    }
}

