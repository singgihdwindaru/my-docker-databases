-- PostgreSQL Initialization Script
-- This script runs automatically when PostgreSQL starts for the first time

-- Create additional database
CREATE DATABASE IF NOT EXISTS testdb;

-- Create additional user with specific permissions
CREATE USER IF NOT EXISTS devuser WITH PASSWORD 'devpass123';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE myapp TO devuser;
GRANT ALL PRIVILEGES ON DATABASE testdb TO devuser;

-- Create a sample table in the main database
\c myapp;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (username, email) VALUES 
    ('admin', 'admin@example.com'),
    ('user1', 'user1@example.com'),
    ('user2', 'user2@example.com')
ON CONFLICT (username) DO NOTHING;

INSERT INTO posts (user_id, title, content) VALUES 
    (1, 'Welcome Post', 'Welcome to our application!'),
    (2, 'User Post 1', 'This is my first post.'),
    (3, 'User Post 2', 'Another interesting post.')
ON CONFLICT DO NOTHING;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at);

-- Grant permissions on tables
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO devuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO devuser;
