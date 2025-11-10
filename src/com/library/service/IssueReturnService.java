package com.library.service;

import com.library.dao.IssueReturnDAO;
import com.library.dao.BookDAO;
import com.library.entity.IssueReturn;
import com.library.entity.IssueReturn.TransactionStatus;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

public class IssueReturnService {
    private IssueReturnDAO issueReturnDAO;
    private BookDAO bookDAO;
    
    public IssueReturnService() {
        this.issueReturnDAO = new IssueReturnDAO();
        this.bookDAO = new BookDAO();
    }
    
    public boolean issueBook(int bookId, int memberId, int issuedBy, int loanDays) {
        // Check if book is available
        if (!bookDAO.isBookAvailable(bookId)) {
            System.out.println("Book is not available!");
            return false;
        }
        
        // Create transaction
        IssueReturn transaction = new IssueReturn();
        transaction.setBookId(bookId);
        transaction.setMemberId(memberId);
        transaction.setIssueDate(new Timestamp(System.currentTimeMillis()));
        transaction.setDueDate(Date.valueOf(LocalDate.now().plusDays(loanDays)));
        transaction.setIssuedBy(issuedBy);
        transaction.setStatus(TransactionStatus.ISSUED);
        transaction.setConditionAtIssue(IssueReturn.Condition.GOOD);
        
        return issueReturnDAO.issueBook(transaction);
    }
    
    public boolean returnBook(int transactionId, int returnedTo) {
        Timestamp returnDate = new Timestamp(System.currentTimeMillis());
        return issueReturnDAO.returnBook(transactionId, returnDate, returnedTo);
    }
    
    public List<IssueReturn> getAllIssuedBooks() {
        return issueReturnDAO.getAllIssuedBooks();
    }
    
    public List<IssueReturn> getBooksByMember(int memberId) {
        return issueReturnDAO.getBooksByMember(memberId);
    }
    
    public List<IssueReturn> getCurrentlyIssuedBooksByMember(int memberId) {
        return issueReturnDAO.getCurrentlyIssuedBooksByMember(memberId);
    }
    
    public List<IssueReturn> getOverdueBooks() {
        return issueReturnDAO.getOverdueBooks();
    }
    
    public IssueReturn getTransactionById(int transactionId) {
        return issueReturnDAO.getTransactionById(transactionId);
    }
    
    public List<IssueReturn> getAllTransactions() {
        return issueReturnDAO.getAllTransactions();
    }
}