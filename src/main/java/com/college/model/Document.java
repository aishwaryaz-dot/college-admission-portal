package com.college.model;

import java.sql.Timestamp;

public class Document {
    private int id;
    private int applicationId;
    private String fileName;
    private String fileType;
    private String filePath;
    private Timestamp uploadedAt;
    private String documentType; // e.g., "transcript", "certificate", "photo"

    // No-argument constructor
    public Document() {
        // Default constructor
    }

    // Constructor
    public Document(int applicationId, String fileName, String fileType, String filePath, String documentType) {
        this.applicationId = applicationId;
        this.fileName = fileName;
        this.fileType = fileType;
        this.filePath = filePath;
        this.documentType = documentType;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }
} 