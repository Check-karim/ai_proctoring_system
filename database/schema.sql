-- AI Proctoring System Database Schema
-- MySQL Database

-- Create database
CREATE DATABASE IF NOT EXISTS ai_proctoring;
USE ai_proctoring;

-- Drop existing tables if they exist (for fresh setup)
DROP TABLE IF EXISTS proctoring_logs;
DROP TABLE IF EXISTS exam_answers;
DROP TABLE IF EXISTS exam_sessions;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS users;

-- =============================================
-- Users Table
-- =============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,  -- Plain text as requested
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    face_encoding TEXT,  -- Stored face encoding for recognition
    profile_image VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Exams Table
-- =============================================
CREATE TABLE exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    duration_minutes INT NOT NULL DEFAULT 60,
    total_marks INT NOT NULL DEFAULT 100,
    passing_marks INT NOT NULL DEFAULT 40,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- =============================================
-- Questions Table
-- =============================================
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(500) NOT NULL,
    option_b VARCHAR(500) NOT NULL,
    option_c VARCHAR(500) NOT NULL,
    option_d VARCHAR(500) NOT NULL,
    correct_option ENUM('A', 'B', 'C', 'D') NOT NULL,
    marks INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- =============================================
-- Exam Sessions Table
-- =============================================
CREATE TABLE exam_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    exam_id INT NOT NULL,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP NULL,
    score INT DEFAULT 0,
    total_questions INT DEFAULT 0,
    correct_answers INT DEFAULT 0,
    status ENUM('in_progress', 'completed', 'flagged', 'terminated') DEFAULT 'in_progress',
    face_verified BOOLEAN DEFAULT FALSE,
    warning_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- =============================================
-- Exam Answers Table
-- =============================================
CREATE TABLE exam_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option ENUM('A', 'B', 'C', 'D'),
    is_correct BOOLEAN DEFAULT FALSE,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES exam_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- =============================================
-- Proctoring Logs Table
-- =============================================
CREATE TABLE proctoring_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    user_id INT NOT NULL,
    event_type ENUM(
        'face_detected',
        'face_not_detected',
        'multiple_faces',
        'face_mismatch',
        'tab_switch',
        'window_blur',
        'suspicious_movement',
        'exam_started',
        'exam_completed',
        'warning_issued',
        'exam_terminated'
    ) NOT NULL,
    severity ENUM('info', 'warning', 'critical') DEFAULT 'info',
    description TEXT,
    screenshot_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES exam_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================
-- Insert Default Admin User
-- =============================================
INSERT INTO users (username, email, password, full_name, role) VALUES
('admin', 'admin@aiproctoring.com', 'admin', 'System Administrator', 'admin');

-- =============================================
-- Insert Sample Exams
-- =============================================
INSERT INTO exams (title, description, duration_minutes, total_marks, passing_marks, created_by) VALUES
('Introduction to Computer Science', 'Basic concepts of computer science including hardware, software, and programming fundamentals.', 30, 50, 20, 1),
('Mathematics Fundamentals', 'Basic mathematics including algebra, geometry, and arithmetic operations.', 45, 100, 40, 1),
('General Knowledge Quiz', 'Test your general knowledge across various topics including science, history, and current affairs.', 20, 30, 12, 1);

-- =============================================
-- Insert Sample Questions for Exam 1
-- =============================================
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) VALUES
(1, 'What does CPU stand for?', 'Central Processing Unit', 'Computer Personal Unit', 'Central Program Utility', 'Computer Processing Unit', 'A', 5),
(1, 'Which of the following is an input device?', 'Monitor', 'Printer', 'Keyboard', 'Speaker', 'C', 5),
(1, 'What is RAM?', 'Read Access Memory', 'Random Access Memory', 'Run Access Memory', 'Read Any Memory', 'B', 5),
(1, 'Which programming language is known as the mother of all languages?', 'Java', 'Python', 'C', 'Assembly', 'C', 5),
(1, 'What does HTML stand for?', 'Hyper Text Markup Language', 'High Tech Modern Language', 'Hyper Transfer Markup Language', 'Home Tool Markup Language', 'A', 5),
(1, 'Which device is used to connect to the internet?', 'Graphics Card', 'Sound Card', 'Modem', 'Power Supply', 'C', 5),
(1, 'What is the binary equivalent of decimal 5?', '100', '101', '110', '111', 'B', 5),
(1, 'Which of the following is an operating system?', 'Microsoft Office', 'Google Chrome', 'Windows 10', 'Adobe Photoshop', 'C', 5),
(1, 'What is the main function of an operating system?', 'Word processing', 'Managing hardware and software', 'Playing games', 'Browsing internet', 'B', 5),
(1, 'Which storage device has the largest capacity?', 'Floppy Disk', 'CD-ROM', 'Hard Disk', 'USB Flash Drive', 'C', 5);

-- =============================================
-- Insert Sample Questions for Exam 2
-- =============================================
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) VALUES
(2, 'What is 15 + 27?', '41', '42', '43', '44', 'B', 10),
(2, 'Solve: 8 × 7 = ?', '54', '56', '58', '64', 'B', 10),
(2, 'What is the square root of 144?', '10', '11', '12', '14', 'C', 10),
(2, 'If x + 5 = 12, what is x?', '5', '6', '7', '8', 'C', 10),
(2, 'What is 25% of 200?', '25', '50', '75', '100', 'B', 10),
(2, 'How many sides does a hexagon have?', '5', '6', '7', '8', 'B', 10),
(2, 'What is the value of π (pi) approximately?', '2.14', '3.14', '4.14', '5.14', 'B', 10),
(2, 'Solve: 100 ÷ 4 = ?', '20', '25', '30', '35', 'B', 10),
(2, 'What is 7² (7 squared)?', '14', '21', '49', '56', 'C', 10),
(2, 'If a triangle has angles of 60° and 80°, what is the third angle?', '30°', '40°', '50°', '60°', 'B', 10);

-- =============================================
-- Insert Sample Questions for Exam 3
-- =============================================
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) VALUES
(3, 'Which planet is known as the Red Planet?', 'Venus', 'Mars', 'Jupiter', 'Saturn', 'B', 3),
(3, 'Who painted the Mona Lisa?', 'Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo', 'C', 3),
(3, 'What is the largest ocean on Earth?', 'Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean', 'D', 3),
(3, 'In which year did World War II end?', '1943', '1944', '1945', '1946', 'C', 3),
(3, 'What is the chemical symbol for gold?', 'Go', 'Gd', 'Au', 'Ag', 'C', 3),
(3, 'Which country is known as the Land of the Rising Sun?', 'China', 'Japan', 'Korea', 'Thailand', 'B', 3),
(3, 'What is the largest mammal?', 'Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus', 'B', 3),
(3, 'Who wrote Romeo and Juliet?', 'Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain', 'B', 3),
(3, 'What is the capital of France?', 'London', 'Berlin', 'Madrid', 'Paris', 'D', 3),
(3, 'Which element has the atomic number 1?', 'Helium', 'Hydrogen', 'Oxygen', 'Carbon', 'B', 3);

-- =============================================
-- Create Indexes for Better Performance
-- =============================================
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_exam_sessions_user ON exam_sessions(user_id);
CREATE INDEX idx_exam_sessions_exam ON exam_sessions(exam_id);
CREATE INDEX idx_proctoring_logs_session ON proctoring_logs(session_id);
CREATE INDEX idx_proctoring_logs_user ON proctoring_logs(user_id);
CREATE INDEX idx_proctoring_logs_event ON proctoring_logs(event_type);

-- =============================================
-- View for Exam Statistics
-- =============================================
CREATE OR REPLACE VIEW exam_statistics AS
SELECT 
    e.id AS exam_id,
    e.title AS exam_title,
    COUNT(DISTINCT es.id) AS total_attempts,
    COUNT(DISTINCT CASE WHEN es.status = 'completed' THEN es.id END) AS completed_attempts,
    COUNT(DISTINCT CASE WHEN es.status = 'flagged' THEN es.id END) AS flagged_attempts,
    AVG(CASE WHEN es.status = 'completed' THEN es.score END) AS average_score,
    MAX(es.score) AS highest_score,
    MIN(CASE WHEN es.status = 'completed' THEN es.score END) AS lowest_score
FROM exams e
LEFT JOIN exam_sessions es ON e.id = es.exam_id
GROUP BY e.id, e.title;

-- =============================================
-- View for Proctoring Summary
-- =============================================
CREATE OR REPLACE VIEW proctoring_summary AS
SELECT 
    DATE(created_at) AS log_date,
    event_type,
    severity,
    COUNT(*) AS event_count
FROM proctoring_logs
GROUP BY DATE(created_at), event_type, severity
ORDER BY log_date DESC, event_count DESC;
