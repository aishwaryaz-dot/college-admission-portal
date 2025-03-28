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
        String query = "INSERT INTO applications (user_id, program, status) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            // Get the user ID from the student's user object
            User user = application.getStudent().getUser();
            Long userId = user != null ? user.getId() : null;
            
            if (userId == null) {
                return false;
            }
            
            stmt.setLong(1, userId);
            stmt.setString(2, application.getProgram());
            stmt.setString(3, application.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        application.setId(generatedKeys.getLong(1));
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
        String query = "SELECT a.*, s.first_name, s.last_name, s.date_of_birth, s.phone, s.address " +
                      "FROM applications a " +
                      "LEFT JOIN students s ON a.user_id = s.user_id " +
                      "WHERE a.id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        String query = "SELECT a.*, s.first_name, s.last_name, s.date_of_birth, s.phone, s.address " +
                      "FROM applications a " +
                      "LEFT JOIN students s ON a.user_id = s.user_id " +
                      "WHERE a.user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setLong(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Application app = extractApplicationFromResultSet(rs);
                    applications.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return applications;
    }
    
    public List<Application> getAllApplications() {
        List<Application> applications = new ArrayList<>();
        
        String query = "SELECT a.*, s.first_name, s.last_name, s.date_of_birth, s.phone, s.address " +
                      "FROM applications a " +
                      "LEFT JOIN students s ON a.user_id = s.user_id";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Application app = extractApplicationFromResultSet(rs);
                applications.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return applications;
    }
    
    public boolean updateApplicationStatus(Long applicationId, String status) {
        String query = "UPDATE applications SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, status);
            stmt.setLong(2, applicationId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private Application extractApplicationFromResultSet(ResultSet rs) throws SQLException {
        Application application = new Application();
        application.setId(rs.getLong("id"));
        application.setProgram(rs.getString("program"));
        application.setStatus(rs.getString("status"));
        application.setSubmissionDate(rs.getTimestamp("created_at"));
        application.setLastUpdated(rs.getTimestamp("updated_at"));
        
        // Create student object
        Student student = new Student();
        student.setFirstName(rs.getString("first_name"));
        student.setLastName(rs.getString("last_name"));
        student.setDateOfBirth(rs.getDate("date_of_birth"));
        student.setPhone(rs.getString("phone"));
        student.setAddress(rs.getString("address"));
        
        // Get user ID from application
        long userId = rs.getLong("user_id");
        User user = userDAO.getUserById(userId);
        student.setUser(user);
        
        // Set student to application
        application.setStudent(student);
        
        // Set documents for the application
        List<Document> documents = documentDAO.getDocumentsByApplicationId(application.getId());
        application.setDocuments(documents);
        
        return application;
    }
} 