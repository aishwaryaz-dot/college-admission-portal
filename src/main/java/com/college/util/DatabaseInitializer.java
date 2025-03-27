package com.college.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DatabaseInitializer {
    
    // List of required tables
    private static final List<String> REQUIRED_TABLES = Arrays.asList(
        "users", "students", "applications", "documents"
    );
    
    /**
     * Check if the database is initialized with all required tables
     * If not, initialize it using the built-in schema
     */
    public static void initializeIfNeeded() {
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Check if all required tables exist
            if (!allTablesExist(conn)) {
                System.out.println("Database schema missing or incomplete. Initializing database...");
                initializeDatabase(conn);
                System.out.println("Database initialization complete.");
            } else {
                System.out.println("Database schema already exists.");
            }
        } catch (SQLException e) {
            System.err.println("Error initializing database: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Check if all required tables exist in the database
     */
    private static boolean allTablesExist(Connection conn) throws SQLException {
        DatabaseMetaData metaData = conn.getMetaData();
        List<String> existingTables = new ArrayList<>();
        
        // Get all tables in the database
        try (ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"})) {
            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME").toLowerCase();
                existingTables.add(tableName);
            }
        }
        
        // Check if all required tables exist
        for (String requiredTable : REQUIRED_TABLES) {
            if (!existingTables.contains(requiredTable.toLowerCase())) {
                System.out.println("Missing table: " + requiredTable);
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Execute SQL statements to create database schema
     */
    private static void initializeDatabase(Connection conn) throws SQLException {
        // SQL statements to create tables
        List<String> sqlStatements = getSchemaStatements();
        
        // Execute each SQL statement
        try (Statement stmt = conn.createStatement()) {
            for (String sql : sqlStatements) {
                if (!sql.trim().isEmpty()) {
                    try {
                        stmt.execute(sql);
                        System.out.println("Executed SQL: " + sql.substring(0, Math.min(50, sql.length())) + "...");
                    } catch (SQLException e) {
                        System.err.println("Error executing SQL: " + sql);
                        System.err.println("Error message: " + e.getMessage());
                        // Continue with next statement even if this one fails
                    }
                }
            }
        }
    }
    
    /**
     * Get SQL statements for database initialization
     * This hardcodes the schema in case we can't read from a file
     */
    private static List<String> getSchemaStatements() {
        List<String> statements = new ArrayList<>();
        
        // Users table - modified to match the User model (email instead of username)
        statements.add(
            "CREATE TABLE IF NOT EXISTS users (" +
            "id SERIAL PRIMARY KEY, " +
            "email VARCHAR(100) NOT NULL UNIQUE, " +
            "password VARCHAR(100) NOT NULL, " +
            "role VARCHAR(20) NOT NULL, " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")"
        );
        
        // Insert admin user with appropriate syntax based on database type
        if (DatabaseUtil.isPostgresql()) {
            statements.add(
                "INSERT INTO users (email, password, role) " +
                "VALUES ('admin@college.com', 'admin123', 'ADMIN') " +
                "ON CONFLICT (email) DO NOTHING"
            );
        } else {
            // MySQL syntax
            statements.add(
                "INSERT IGNORE INTO users (email, password, role) " +
                "VALUES ('admin@college.com', 'admin123', 'ADMIN')"
            );
        }
        
        // Students table
        statements.add(
            "CREATE TABLE IF NOT EXISTS students (" +
            "id SERIAL PRIMARY KEY, " +
            "user_id INTEGER REFERENCES users(id), " +
            "first_name VARCHAR(50) NOT NULL, " +
            "last_name VARCHAR(50) NOT NULL, " +
            "date_of_birth DATE, " +
            "phone VARCHAR(20), " +
            "address TEXT, " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")"
        );
        
        // Applications table
        statements.add(
            "CREATE TABLE IF NOT EXISTS applications (" +
            "id SERIAL PRIMARY KEY, " +
            "student_id INTEGER REFERENCES students(id), " +
            "program VARCHAR(100) NOT NULL, " +
            "status VARCHAR(20) DEFAULT 'PENDING', " +
            "submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")"
        );
        
        // Documents table
        statements.add(
            "CREATE TABLE IF NOT EXISTS documents (" +
            "id SERIAL PRIMARY KEY, " +
            "application_id INTEGER REFERENCES applications(id), " +
            "document_type VARCHAR(50) NOT NULL, " +
            "document_path VARCHAR(255) NOT NULL, " +
            "upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")"
        );
        
        return statements;
    }
} 