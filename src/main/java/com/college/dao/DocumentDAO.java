package com.college.dao;

import com.college.model.Document;
import com.college.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {
    
    public int saveDocument(Document document) throws SQLException {
        String sql = "INSERT INTO documents (application_id, file_name, file_path, document_type, uploaded_at) " +
                    "VALUES (?, ?, ?, ?, NOW())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, document.getApplicationId());
            pstmt.setString(2, document.getFileName());
            pstmt.setString(3, document.getFilePath());
            pstmt.setString(4, document.getDocumentType());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating document failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating document failed, no ID obtained.");
                }
            }
        }
    }
    
    public List<Document> getDocumentsByApplicationId(int applicationId) throws SQLException {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM documents WHERE application_id = ? ORDER BY uploaded_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, applicationId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
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
        }
        return documents;
    }
    
    public Document getDocumentById(int documentId) throws SQLException {
        String sql = "SELECT * FROM documents WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, documentId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Document document = new Document(
                        rs.getInt("application_id"),
                        rs.getString("file_name"),
                        null, // file_type is not in the database
                        rs.getString("file_path"),
                        rs.getString("document_type")
                    );
                    document.setId(rs.getInt("id"));
                    document.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    return document;
                }
            }
        }
        return null;
    }
    
    public boolean deleteDocument(int documentId) throws SQLException {
        String sql = "DELETE FROM documents WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, documentId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
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