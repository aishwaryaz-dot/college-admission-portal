package com.college.dao;

import com.college.model.Message;
import com.college.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean saveMessage(Message message) {
        String query = "INSERT INTO messages (user_id, message, is_from_admin) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setLong(1, message.getUserId());
            stmt.setString(2, message.getMessage());
            stmt.setBoolean(3, message.isFromAdmin());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Message> getMessagesByUserId(Long userId) {
        List<Message> messages = new ArrayList<>();
        String query = "SELECT * FROM messages WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setLong(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message message = new Message();
                    message.setId(rs.getLong("id"));
                    message.setUserId(rs.getLong("user_id"));
                    message.setMessage(rs.getString("message"));
                    message.setFromAdmin(rs.getBoolean("is_from_admin"));
                    message.setCreatedAt(rs.getTimestamp("created_at"));
                    messages.add(message);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return messages;
    }
    
    public List<Message> getAllMessages() {
        List<Message> messages = new ArrayList<>();
        String query = "SELECT * FROM messages ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Message message = new Message();
                message.setId(rs.getLong("id"));
                message.setUserId(rs.getLong("user_id"));
                message.setMessage(rs.getString("message"));
                message.setFromAdmin(rs.getBoolean("is_from_admin"));
                message.setCreatedAt(rs.getTimestamp("created_at"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return messages;
    }
    
    public Message getMessageById(Long messageId) {
        String query = "SELECT * FROM messages WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setLong(1, messageId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Message message = new Message();
                    message.setId(rs.getLong("id"));
                    message.setUserId(rs.getLong("user_id"));
                    message.setMessage(rs.getString("message"));
                    message.setFromAdmin(rs.getBoolean("is_from_admin"));
                    message.setCreatedAt(rs.getTimestamp("created_at"));
                    return message;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
} 