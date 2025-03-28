package com.college.model;

import java.util.Date;
import java.sql.Timestamp;

public class Document {
    private Long id;
    private Long applicationId;
    private String documentType;
    private String fileName;
    private String filePath;
    private Timestamp uploadDate;

    // No-argument constructor
    public Document() {
        // Default constructor
    }

    // Constructor
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

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
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

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    // For backward compatibility
    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadDate = uploadedAt;
    }
} 