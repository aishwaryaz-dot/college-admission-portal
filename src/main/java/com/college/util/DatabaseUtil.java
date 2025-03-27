package com.college.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DatabaseUtil {
    // Default local development settings
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/admission_db";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "gaurav685";
    
    // Parse PostgreSQL URL if present (for Render.com)
    private static final PostgresConnectionInfo PG_CONNECTION_INFO = parsePostgresUrl();
    
    // Get configuration from environment variables if available
    private static final String URL = PG_CONNECTION_INFO != null ? PG_CONNECTION_INFO.jdbcUrl : DEFAULT_URL;
    private static final String USER = PG_CONNECTION_INFO != null ? PG_CONNECTION_INFO.username : DEFAULT_USER;
    private static final String PASSWORD = PG_CONNECTION_INFO != null ? PG_CONNECTION_INFO.password : DEFAULT_PASSWORD;

    static {
        try {
            // Detect driver based on URL
            if (isPostgresql()) {
                Class.forName("org.postgresql.Driver");
            } else {
                Class.forName("com.mysql.cj.jdbc.Driver");
            }
            System.out.println("Using database URL: " + URL);
            System.out.println("Using database USER: " + USER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Check if the configured database is PostgreSQL
     * @return true if using PostgreSQL, false otherwise
     */
    public static boolean isPostgresql() {
        return URL.contains("postgresql");
    }
    
    private static PostgresConnectionInfo parsePostgresUrl() {
        String databaseUrl = System.getenv("DATABASE_URL");
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            return null;
        }
        
        System.out.println("Raw DATABASE_URL: " + databaseUrl);
        
        // Parse URL in format: postgresql://username:password@host/database
        Pattern pattern = Pattern.compile("postgresql://([^:]+):([^@]+)@([^/]+)/(.+)");
        Matcher matcher = pattern.matcher(databaseUrl);
        
        if (matcher.matches()) {
            String username = matcher.group(1);
            String password = matcher.group(2);
            String host = matcher.group(3);
            String database = matcher.group(4);
            
            // Construct proper JDBC URL
            String jdbcUrl = "jdbc:postgresql://" + host + "/" + database;
            
            return new PostgresConnectionInfo(jdbcUrl, username, password);
        }
        
        return null;
    }
    
    private static class PostgresConnectionInfo {
        final String jdbcUrl;
        final String username;
        final String password;
        
        PostgresConnectionInfo(String jdbcUrl, String username, String password) {
            this.jdbcUrl = jdbcUrl;
            this.username = username;
            this.password = password;
        }
    }
} 