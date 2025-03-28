package com.college.model;

import java.sql.Timestamp;

public class Document {
    private Long id;
    private Long applicationId;
    private String fileName;
    private String filePath;
    private String documentType;
    private Timestamp uploadedAt;

    // No-argument constructor
    public Document() {
        // Default constructor
    }

    public Document(Long applicationId, String fileName, String filePath, String documentType) {
        this.applicationId = applicationId;
        this.fileName = fileName;
        this.filePath = filePath;
        this.documentType = documentType;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Long applicationId) {
        this.applicationId = applicationId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    // For backward compatibility
    public void setUploadDate(Timestamp date) {
        this.uploadedAt = date;
    }

    public Timestamp getUploadDate() {
        return this.uploadedAt;
    }

    // For backward compatibility with int IDs
    public void setApplicationId(int applicationId) {
        this.applicationId = Long.valueOf(applicationId);
    }

    public void setId(int id) {
        this.id = Long.valueOf(id);
    }
} 