package com.college.dao;

import com.college.model.Message;
import com.college.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    public boolean createMessage(Message message) {
        String sql = "INSERT INTO messages (application_id, sender_id, message) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, message.getApplicationId());
            stmt.setInt(2, message.getSenderId());
            stmt.setString(3, message.getMessage());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getMessagesByApplicationId(int applicationId) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT m.*, u.email as sender_name, u.role as sender_role " +
                    "FROM messages m " +
                    "JOIN users u ON m.sender_id = u.id " +
                    "WHERE m.application_id = ? " +
                    "ORDER BY m.created_at ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, applicationId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Message message = new Message();
                message.setId(rs.getInt("id"));
                message.setApplicationId(rs.getInt("application_id"));
                message.setSenderId(rs.getInt("sender_id"));
                message.setMessage(rs.getString("message"));
                message.setCreatedAt(rs.getTimestamp("created_at"));
                message.setSenderName(rs.getString("sender_name"));
                message.setSenderRole(rs.getString("sender_role"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    public boolean deleteMessagesByApplicationId(int applicationId) {
        String sql = "DELETE FROM messages WHERE application_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, applicationId);
            return stmt.executeUpdate() >= 0; // Return true even if no messages were deleted
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
} 