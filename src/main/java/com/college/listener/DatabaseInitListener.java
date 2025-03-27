package com.college.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.college.util.DatabaseInitializer;

/**
 * Application lifecycle listener that initializes the database
 * during application startup
 */
@WebListener
public class DatabaseInitListener implements ServletContextListener {

    /**
     * Initialize database when the web application is starting
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Initializing database schema...");
        DatabaseInitializer.initializeIfNeeded();
    }

    /**
     * Cleanup when the web application is shutting down
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // No cleanup needed
    }
} 