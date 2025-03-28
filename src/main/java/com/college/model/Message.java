package com.college.model;

import java.sql.Timestamp;

public class Message {
    private Long id;
    private Long userId;
    private String message;
    private boolean fromAdmin;
    private Timestamp createdAt;
    
    public Message() {
    }
    
    public Message(Long userId, String message, boolean fromAdmin) {
        this.userId = userId;
        this.message = message;
        this.fromAdmin = fromAdmin;
    }
    
    // Getters and setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public boolean isFromAdmin() {
        return fromAdmin;
    }
    
    public void setFromAdmin(boolean fromAdmin) {
        this.fromAdmin = fromAdmin;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // For backward compatibility
    public int getApplicationId() {
        return userId != null ? userId.intValue() : 0;
    }
    
    public void setApplicationId(int applicationId) {
        this.userId = Long.valueOf(applicationId);
    }
    
    public int getSenderId() {
        return userId != null ? userId.intValue() : 0;
    }
    
    public void setSenderId(int senderId) {
        this.userId = Long.valueOf(senderId);
    }
    
    public void setSenderName(String senderName) {
        // Compatibility method, no-op
    }
    
    public void setSenderRole(String senderRole) {
        // Compatibility method, no-op
    }
} 