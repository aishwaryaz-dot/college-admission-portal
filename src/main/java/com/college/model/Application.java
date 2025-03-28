package com.college.model;

import java.util.Date;
import java.util.List;
import java.sql.Timestamp;

public class Application {
    private Long id;
    private Student student;
    private String program;
    private String status; // "PENDING", "APPROVED", "REJECTED"
    private Date submissionDate;
    private Date lastUpdated;
    private String personalStatement;
    private List<Document> documents;
    private Timestamp createdAt;
    
    public Application() {
    }
    
    public Application(Long id, Student student, String program, String status, 
                      Date submissionDate, Date lastUpdated, String personalStatement) {
        this.id = id;
        this.student = student;
        this.program = program;
        this.status = status;
        this.submissionDate = submissionDate;
        this.lastUpdated = lastUpdated;
        this.personalStatement = personalStatement;
    }
    
    // Getters and setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Student getStudent() {
        return student;
    }
    
    public void setStudent(Student student) {
        this.student = student;
    }
    
    public String getProgram() {
        return program;
    }
    
    public void setProgram(String program) {
        this.program = program;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getSubmissionDate() {
        return submissionDate;
    }
    
    public void setSubmissionDate(Date submissionDate) {
        this.submissionDate = submissionDate;
    }
    
    public Date getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    public String getPersonalStatement() {
        return personalStatement;
    }
    
    public void setPersonalStatement(String personalStatement) {
        this.personalStatement = personalStatement;
    }
    
    public List<Document> getDocuments() {
        return documents;
    }
    
    public void setDocuments(List<Document> documents) {
        this.documents = documents;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
} 