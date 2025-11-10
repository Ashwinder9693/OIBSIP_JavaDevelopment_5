package com.library.servlet;

import com.library.entity.User;
import com.library.entity.Reservation;
import com.library.service.ReservationService;
import com.library.service.BookService;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/reservations")
public class MyReservationsServlet extends HttpServlet {
    private ReservationService reservationService;
    private BookService bookService;
    
    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService();
        bookService = new BookService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        try {
            // Get all reservations for the user
            List<Reservation> reservations = reservationService.getUserReservations(user.getUserId());
            
            // Create a list of reservations with book details
            List<Map<String, Object>> reservationDetails = new ArrayList<>();
            if (reservations != null) {
                for (Reservation reservation : reservations) {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("reservation", reservation);
                    
                    // Get book details
                    Book book = bookService.getBookById(reservation.getBookId());
                    detail.put("book", book);
                    
                    reservationDetails.add(detail);
                }
            }
            
            request.setAttribute("reservations", reservationDetails);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("reservations", new ArrayList<>());
        }
        
        request.getRequestDispatcher("/jsp/user/myReservations.jsp").forward(request, response);
    }
}

