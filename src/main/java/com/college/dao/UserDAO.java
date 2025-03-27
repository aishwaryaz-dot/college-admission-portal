package com.college.dao;

import com.college.model.User;
import com.college.util.DatabaseUtil;

import java.sql.*;

public class UserDAO {
    public UserDAO() {
        // Admin will be created by DatabaseInitializer now
        // No need to call createAdminIfNotExists() here
    }

    /**
     * This method is kept for backward compatibility but is no longer called in the constructor
     * as the admin user is now created by the DatabaseInitializer
     */
    private void createAdminIfNotExists() {
        String sql = "SELECT * FROM users WHERE email = 'admin@college.com'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            if (!rs.next()) {
                // Admin doesn't exist, create it
                User admin = new User("admin@college.com", "admin123", "ADMIN");
                registerUser(admin);
            }
        } catch (SQLException e) {
            System.err.println("Error checking for admin user: " + e.getMessage());
            // Don't rethrow - this is expected to fail if tables don't exist yet
        }
    }

    public User authenticate(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Authentication error: " + e.getMessage());
        }
        return null;
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (email, password, role) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("User registration error: " + e.getMessage());
            return false;
        }
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
        }
        return null;
    }
} 