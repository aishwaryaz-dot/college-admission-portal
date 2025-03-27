package com.college.servlet;

import com.college.dao.ApplicationDAO;
import com.college.dao.DocumentDAO;
import com.college.dao.MessageDAO;
import com.college.dao.UserDAO;
import com.college.model.Document;
import com.college.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.college.util.DatabaseUtil;

@WebServlet("/admin/clear-data")
public class ClearDatabaseServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        // Only admin can access this endpoint
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin/clear-data.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        // Only admin can access this endpoint
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String confirm = request.getParameter("confirm");
        if (!"DELETE_ALL_STUDENT_DATA".equals(confirm)) {
            session.setAttribute("errorMessage", "Confirmation phrase doesn't match. No data was deleted.");
            response.sendRedirect(request.getContextPath() + "/admin/clear-data");
            return;
        }
        
        try {
            // First, delete all document files
            List<Document> allDocuments = new DocumentDAO().getAllDocuments();
            for (Document doc : allDocuments) {
                String filePath = getServletContext().getRealPath("") + File.separator + doc.getFilePath();
                File file = new File(filePath);
                if (file.exists()) {
                    file.delete();
                }
            }
            
            // Delete data from the database
            try (Connection conn = DatabaseUtil.getConnection()) {
                conn.setAutoCommit(false);
                
                try {
                    // Delete all messages
                    try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM messages")) {
                        stmt.executeUpdate();
                    }
                    
                    // Delete all documents
                    try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM documents")) {
                        stmt.executeUpdate();
                    }
                    
                    // Delete all applications from students
                    try (PreparedStatement stmt = conn.prepareStatement(
                            "DELETE FROM applications WHERE (SELECT role FROM users WHERE users.id = applications.user_id) = 'STUDENT'")) {
                        stmt.executeUpdate();
                    }
                    
                    // Delete all student users
                    try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE role = 'STUDENT'")) {
                        stmt.executeUpdate();
                    }
                    
                    // Commit the transaction
                    conn.commit();
                    
                    session.setAttribute("successMessage", "All student data has been cleared successfully.");
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error clearing data: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/clear-data");
    }
} 