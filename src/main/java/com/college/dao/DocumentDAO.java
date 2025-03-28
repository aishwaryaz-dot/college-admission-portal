package com.college.dao;

import com.college.model.Document;
import com.college.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {
    
    public List<Document> getDocumentsByApplicationId(Long applicationId) {
        List<Document> documents = new ArrayList<>();
        String query = "SELECT * FROM documents WHERE application_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setLong(1, applicationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Document document = new Document();
                    document.setId(rs.getLong("id"));
                    document.setApplicationId(rs.getLong("application_id"));
                    document.setDocumentType(rs.getString("document_type"));
                    document.setFileName(rs.getString("file_name"));
                    document.setFilePath(rs.getString("file_path"));
                    document.setUploadDate(rs.getTimestamp("upload_date"));
                    documents.add(document);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return documents;
    }
    
    public boolean saveDocument(Document document) {
        String query = "INSERT INTO documents (application_id, document_type, file_name, file_path) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, document.getApplicationId());
            stmt.setString(2, document.getDocumentType());
            stmt.setString(3, document.getFileName());
            stmt.setString(4, document.getFilePath());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        document.setId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean deleteDocument(Long documentId) {
        String query = "DELETE FROM documents WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setLong(1, documentId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Document getDocumentById(Long documentId) {
        String query = "SELECT * FROM documents WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setLong(1, documentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Document document = new Document();
                    document.setId(rs.getLong("id"));
                    document.setApplicationId(rs.getLong("application_id"));
                    document.setDocumentType(rs.getString("document_type"));
                    document.setFileName(rs.getString("file_name"));
                    document.setFilePath(rs.getString("file_path"));
                    document.setUploadDate(rs.getTimestamp("upload_date"));
                    return document;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean deleteDocumentsByApplicationId(int applicationId) throws SQLException {
        String sql = "DELETE FROM documents WHERE application_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, applicationId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows >= 0; // Return true even if no documents were deleted
        }
    }
    
    public List<Document> getAllDocuments() throws SQLException {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM documents";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Document document = new Document(
                    rs.getInt("application_id"),
                    rs.getString("file_name"),
                    null, // file_type is not in the database
                    rs.getString("file_path"),
                    rs.getString("document_type")
                );
                document.setId(rs.getInt("id"));
                document.setUploadedAt(rs.getTimestamp("uploaded_at"));
                documents.add(document);
            }
        }
        return documents;
    }
} 