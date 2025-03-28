package com.college.dao;

import com.college.model.Document;
import com.college.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {
    
    public List<Document> getDocumentsByApplicationId(Long applicationId) {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM documents WHERE application_id = ? ORDER BY uploaded_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, applicationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    documents.add(extractDocumentFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return documents;
    }
    
    public boolean saveDocument(Document document) {
        String sql = "INSERT INTO documents (application_id, document_type, file_name, file_path, uploaded_at) VALUES (?, ?, ?, ?, NOW())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, document.getApplicationId());
            stmt.setString(2, document.getDocumentType());
            stmt.setString(3, document.getFileName());
            stmt.setString(4, document.getFilePath());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        document.setId(rs.getLong(1));
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
        String sql = "DELETE FROM documents WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, documentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Document getDocumentById(Long documentId) {
        String sql = "SELECT * FROM documents WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, documentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDocumentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean deleteDocumentsByApplicationId(Long applicationId) {
        String sql = "DELETE FROM documents WHERE application_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, applicationId);
            
            return stmt.executeUpdate() >= 0; // Return true even if no documents were deleted
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Document> getAllDocuments() {
        List<Document> documents = new ArrayList<>();
        String query = "SELECT * FROM documents";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return documents;
    }
    
    private Document extractDocumentFromResultSet(ResultSet rs) throws SQLException {
        Document document = new Document();
        document.setId(rs.getLong("id"));
        document.setApplicationId(rs.getLong("application_id"));
        document.setDocumentType(rs.getString("document_type"));
        document.setFileName(rs.getString("file_name"));
        document.setFilePath(rs.getString("file_path"));
        document.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return document;
    }
} 