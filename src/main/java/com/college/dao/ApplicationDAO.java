package com.college.dao;

import com.college.model.Application;
import com.college.model.Document;
import com.college.model.Student;
import com.college.model.User;
import com.college.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {
    private DocumentDAO documentDAO;
    private UserDAO userDAO;
    
    public ApplicationDAO() {
        this.documentDAO = new DocumentDAO();
        this.userDAO = new UserDAO();
    }
    
    public boolean createApplication(Application application) {
        String sql = "INSERT INTO applications (student_id, program, status, created_at) VALUES (?, ?, ?, NOW())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, application.getStudent().getId());
            stmt.setString(2, application.getProgram());
            stmt.setString(3, application.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        application.setId(rs.getLong(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Application getApplicationById(Long applicationId) {
        String sql = "SELECT a.*, s.* FROM applications a " +
                    "JOIN students s ON a.student_id = s.id " +
                    "WHERE a.id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, applicationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractApplicationFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Application> getApplicationsByUserId(Long userId) {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT a.*, s.* FROM applications a " +
                    "JOIN students s ON a.student_id = s.id " +
                    "WHERE s.user_id = ? " +
                    "ORDER BY a.created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    applications.add(extractApplicationFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }
    
    public List<Application> getAllApplications() {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT a.*, s.* FROM applications a " +
                    "JOIN students s ON a.student_id = s.id " +
                    "ORDER BY a.created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                applications.add(extractApplicationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }
    
    public boolean updateApplicationStatus(Long applicationId, String status) {
        String sql = "UPDATE applications SET status = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setLong(2, applicationId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteApplication(Long applicationId) {
        String sql = "DELETE FROM applications WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, applicationId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Application extractApplicationFromResultSet(ResultSet rs) throws SQLException {
        Application application = new Application();
        application.setId(rs.getLong("id"));
        application.setProgram(rs.getString("program"));
        application.setStatus(rs.getString("status"));
        application.setCreatedAt(rs.getTimestamp("created_at"));
        
        Student student = new Student();
        student.setId(rs.getLong("student_id"));
        student.setFirstName(rs.getString("first_name"));
        student.setLastName(rs.getString("last_name"));
        student.setDateOfBirth(rs.getDate("date_of_birth"));
        student.setPhone(rs.getString("phone"));
        student.setAddress(rs.getString("address"));
        
        application.setStudent(student);
        
        // Set documents for the application
        List<Document> documents = documentDAO.getDocumentsByApplicationId(application.getId());
        application.setDocuments(documents);
        
        return application;
    }
} 