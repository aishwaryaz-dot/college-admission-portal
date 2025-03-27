package com.college.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    // Default local development settings
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/admission_db";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "gaurav685";
    
    // Get configuration from environment variables if available
    private static final String URL = getEnvOrDefault("JDBC_DATABASE_URL", DEFAULT_URL);
    private static final String USER = getEnvOrDefault("SPRING_DATASOURCE_USERNAME", DEFAULT_USER);
    private static final String PASSWORD = getEnvOrDefault("SPRING_DATASOURCE_PASSWORD", DEFAULT_PASSWORD);

    static {
        try {
            // Detect driver based on URL
            if (URL.contains("postgresql")) {
                Class.forName("org.postgresql.Driver");
            } else {
                Class.forName("com.mysql.cj.jdbc.Driver");
            }
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
    
    private static String getEnvOrDefault(String envName, String defaultValue) {
        String value = System.getenv(envName);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }
} 