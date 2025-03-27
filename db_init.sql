-- Initialize database schema for college admission system
-- Compatible with both PostgreSQL and MySQL

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert admin user (PostgreSQL syntax)
INSERT INTO users (email, password, role)
VALUES ('admin@college.com', 'admin123', 'ADMIN')
ON CONFLICT (email) DO NOTHING;

-- MySQL equivalent admin insert (commented out - use for local MySQL)
-- INSERT IGNORE INTO users (email, password, role)
-- VALUES ('admin@college.com', 'admin123', 'ADMIN');

-- Students table
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Applications table
CREATE TABLE IF NOT EXISTS applications (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    program VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Documents table
CREATE TABLE IF NOT EXISTS documents (
    id SERIAL PRIMARY KEY,
    application_id INTEGER REFERENCES applications(id),
    document_type VARCHAR(50) NOT NULL,
    document_path VARCHAR(255) NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 