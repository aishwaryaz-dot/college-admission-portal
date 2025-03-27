package com.college.dao;

import com.college.model.Application;
import com.college.model.Document;
import com.college.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {
    private DocumentDAO documentDAO;

    public ApplicationDAO() {
        try {
            this.documentDAO = new DocumentDAO();
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error initializing DocumentDAO: " + e.getMessage());
        }
    }

    // Helper method to safely get documents
    private List<Document> safeGetDocuments(int applicationId) {
        try {
            if (documentDAO != null) {
                return documentDAO.getDocumentsByApplicationId(applicationId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error getting documents: " + e.getMessage());
        }
        return new ArrayList<>();
    }

    public boolean createApplication(Application application) {
        String sql = "INSERT INTO applications (user_id, first_name, last_name, date_of_birth, phone, address, program, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, application.getUserId());
            stmt.setString(2, application.getFirstName());
            stmt.setString(3, application.getLastName());
            stmt.setDate(4, application.getDateOfBirth());
            stmt.setString(5, application.getPhone());
            stmt.setString(6, application.getAddress());
            stmt.setString(7, application.getProgram());
            stmt.setString(8, application.getStatus());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        application.setId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Application getApplicationById(int id) throws SQLException {
        String sql = "SELECT * FROM applications WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Application application = mapResultSetToApplication(rs);
                    // Safely load documents
                    application.setDocuments(safeGetDocuments(application.getId()));
                    return application;
                }
            }
        }
        return null;
    }

    public List<Application> getApplicationsByUserId(int userId) throws SQLException {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT * FROM applications WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Application application = mapResultSetToApplication(rs);
                    // Safely load documents
                    application.setDocuments(safeGetDocuments(application.getId()));
                    applications.add(application);
                }
            }
        }
        return applications;
    }

    public List<Application> getAllApplications() throws SQLException {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT * FROM applications ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Application application = mapResultSetToApplication(rs);
                // Safely load documents
                application.setDocuments(safeGetDocuments(application.getId()));
                applications.add(application);
            }
        }
        return applications;
    }

    public boolean updateApplicationStatus(int id, String status) {
        String sql = "UPDATE applications SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteApplication(int applicationId) throws SQLException {
        String sql = "DELETE FROM applications WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, applicationId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    private Application mapResultSetToApplication(ResultSet rs) throws SQLException {
        Application application = new Application();
        application.setId(rs.getInt("id"));
        application.setUserId(rs.getInt("user_id"));
        application.setFirstName(rs.getString("first_name"));
        application.setLastName(rs.getString("last_name"));
        application.setDateOfBirth(rs.getDate("date_of_birth"));
        application.setPhone(rs.getString("phone"));
        application.setAddress(rs.getString("address"));
        application.setProgram(rs.getString("program"));
        application.setStatus(rs.getString("status"));
        application.setCreatedAt(rs.getTimestamp("created_at"));
        application.setUpdatedAt(rs.getTimestamp("updated_at"));
        return application;
    }
} 