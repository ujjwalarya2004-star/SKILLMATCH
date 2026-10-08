-- ====================================================================
-- SkillMatch – A Web-Based Freelancer Marketplace Platform
-- Database Setup Script for MySQL
-- Database Name: skillmatch_db
-- ====================================================================

-- 1. Create Database if not exists
CREATE DATABASE IF NOT EXISTS skillmatch_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE skillmatch_db;

-- 2. Drop existing tables in reverse dependency order
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS freelancer_skills;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS freelancer_profiles;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- 3. Create 'users' table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('CLIENT', 'FREELANCER') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. Create 'freelancer_profiles' table
CREATE TABLE freelancer_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    bio TEXT,
    experience VARCHAR(100),
    phone VARCHAR(20),
    location VARCHAR(100),
    portfolio_url VARCHAR(255),
    expertise VARCHAR(200),
    past_projects TEXT,
    CONSTRAINT fk_profile_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Create 'skills' table
CREATE TABLE skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 6. Create 'freelancer_skills' table (Many-to-Many)
CREATE TABLE freelancer_skills (
    freelancer_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (freelancer_id, skill_id),
    CONSTRAINT fk_fs_freelancer FOREIGN KEY (freelancer_id) 
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_fs_skill FOREIGN KEY (skill_id) 
        REFERENCES skills(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. Create 'projects' table
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    budget DECIMAL(10, 2) NOT NULL,
    deadline DATE NOT NULL,
    status ENUM('OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_client FOREIGN KEY (client_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. Create 'applications' table
CREATE TABLE applications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    proposal TEXT NOT NULL,
    proposed_budget DECIMAL(10, 2) NOT NULL,
    status ENUM('PENDING', 'ACCEPTED', 'REJECTED') DEFAULT 'PENDING',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_project_freelancer UNIQUE (project_id, freelancer_id),
    CONSTRAINT fk_app_project FOREIGN KEY (project_id) 
        REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_app_freelancer FOREIGN KEY (freelancer_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. Create 'messages' table (In-App Messaging for Accepted Projects)
CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_msg_project FOREIGN KEY (project_id) 
        REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_sender FOREIGN KEY (sender_id) 
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_receiver FOREIGN KEY (receiver_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ====================================================================
-- SAMPLE DATA SEEDING
-- Passwords are hashed with SHA-256 for:
-- "client123"     -> 186474c1f2c2f735a54c2cf82ee8e87f2a5cd30940e280029363fecedfc5328c
-- "freelancer123" -> 7a192f50ec4a3babf131cf8dec61c8136435e98ab6960c59d1eb87ed582e17da
-- ====================================================================

-- 1. Insert Initial Users
INSERT INTO users (id, name, email, password, role) VALUES
(1, 'TechCorp Solutions', 'client@skillmatch.com', '186474c1f2c2f735a54c2cf82ee8e87f2a5cd30940e280029363fecedfc5328c', 'CLIENT'),
(2, 'Apex Retailers', 'apex@client.com', '186474c1f2c2f735a54c2cf82ee8e87f2a5cd30940e280029363fecedfc5328c', 'CLIENT'),
(3, 'Alex Johnson', 'freelancer@skillmatch.com', '7a192f50ec4a3babf131cf8dec61c8136435e98ab6960c59d1eb87ed582e17da', 'FREELANCER'),
(4, 'Sarah Miller', 'sarah@freelancer.com', '7a192f50ec4a3babf131cf8dec61c8136435e98ab6960c59d1eb87ed582e17da', 'FREELANCER'),
(5, 'David Chen', 'david@freelancer.com', '7a192f50ec4a3babf131cf8dec61c8136435e98ab6960c59d1eb87ed582e17da', 'FREELANCER');

-- 2. Insert Skills Master Data
INSERT INTO skills (id, skill_name) VALUES
(1, 'Java'),
(2, 'MySQL'),
(3, 'JSP & Servlets'),
(4, 'HTML & CSS'),
(5, 'JavaScript'),
(6, 'React'),
(7, 'Spring Boot'),
(8, 'Python'),
(9, 'UI/UX Design'),
(10, 'Cloud & DevOps');

-- 3. Insert Freelancer Profiles
INSERT INTO freelancer_profiles (user_id, bio, experience, phone, location, portfolio_url, expertise, past_projects) VALUES
(3, 'Full-stack Java & Web Developer with 3+ years experience building robust business web applications and relational databases.', '3+ Years', '+1 555-019-2834', 'New York, USA', 'https://alexjohnson.dev', 'Enterprise Web Systems, High-throughput SQL, REST APIs', '• Warehouse stock scanner with barcode generation\n• Multi-tenant billing portal processing 10k orders/day\n• Automated invoice generator with PDF exports'),
(4, 'Frontend specialist and UI designer passionate about intuitive user interfaces, clean HTML5/CSS3 and responsive layouts.', '4 Years', '+1 555-048-9123', 'San Francisco, USA', 'https://sarahmiller.design', 'Modern CSS3, Design Systems, Responsive SPAs, Accessibility', '• Complete brand rebrand for Fintech startup\n• SaaS Analytics dashboard with interactive charts\n• Mobile-first e-commerce checkout redesign with +24% conversion'),
(5, 'Database architect and backend engineer specializing in high-throughput SQL query optimization and REST APIs.', '5 Years', '+1 555-082-4411', 'Chicago, USA', 'https://davidchen.io', 'Database Architecture, PostgreSQL/MySQL tuning, Distributed Systems', '• Migration of legacy monolith database to sharded cluster\n• Real-time telemetry ingest service handling 50k events/sec\n• Custom audit logging framework with zero downtime');

-- 4. Map Freelancers to Skills
INSERT INTO freelancer_skills (freelancer_id, skill_id) VALUES
(3, 1), -- Alex: Java
(3, 2), -- Alex: MySQL
(3, 3), -- Alex: JSP & Servlets
(3, 5), -- Alex: JavaScript
(4, 4), -- Sarah: HTML & CSS
(4, 5), -- Sarah: JavaScript
(4, 9), -- Sarah: UI/UX Design
(5, 1), -- David: Java
(5, 2), -- David: MySQL
(5, 8); -- David: Python

-- 5. Insert Projects
INSERT INTO projects (id, client_id, title, description, budget, deadline, status, created_at) VALUES
(1, 1, 'E-Commerce Inventory Management System', 'Develop a web-based portal to track real-time stock levels, generate purchase orders, and integrate with barcode scanners. Must include role-based access control and daily sales reports.', 1800.00, '2026-11-15', 'OPEN', NOW()),
(2, 1, 'Hospital Patient Appointment Booking Portal', 'Build an automated doctor appointment booking system with SMS reminders, medical history storage, and calendar slot management.', 2400.00, '2026-12-01', 'OPEN', NOW()),
(3, 2, 'Corporate Brand Identity & Responsive Website', 'Complete redesign of corporate website with modern CSS grid layouts, contact forms with validation, and performance optimization.', 1200.00, '2026-10-30', 'IN_PROGRESS', NOW()),
(4, 2, 'Automated Invoice Generator & PDF Exporter', 'A servlet-backed utility to generate customized tax invoices with PDF export and email dispatch to clients.', 950.00, '2026-11-20', 'OPEN', NOW());

-- 6. Insert Applications
INSERT INTO applications (id, project_id, freelancer_id, proposal, proposed_budget, status, applied_at) VALUES
(1, 1, 3, 'I have built multiple inventory management systems using Java, JDBC and MySQL. I can deliver clean code with a responsive JSP frontend within 3 weeks.', 1750.00, 'PENDING', NOW()),
(2, 1, 5, 'My extensive experience in SQL indexing and transactional consistency makes me ideal for handling inventory concurrency. I propose 4 weeks delivery.', 1800.00, 'PENDING', NOW()),
(3, 3, 4, 'I will craft a stunning brand identity and pixel-perfect responsive web templates. Portfolio includes 10+ corporate websites.', 1200.00, 'ACCEPTED', NOW());

-- 7. Insert Sample Chat Messages (for accepted project #3 between Client #2 and Freelancer #4)
INSERT INTO messages (id, project_id, sender_id, receiver_id, message_text, sent_at, is_read) VALUES
(1, 3, 2, 4, 'Hello Sarah! Welcome aboard. We have accepted your proposal for the Corporate Brand Identity project.', DATE_SUB(NOW(), INTERVAL 2 HOUR), TRUE),
(2, 3, 4, 2, 'Thank you so much! I am thrilled to get started. Could you share your preferred brand color palette and logo assets?', DATE_SUB(NOW(), INTERVAL 90 MINUTE), TRUE),
(3, 3, 2, 4, 'Sure thing, our primary tone is navy blue with gold accents. I will prepare the design brief document.', DATE_SUB(NOW(), INTERVAL 45 MINUTE), TRUE),
(4, 3, 4, 2, 'Received! I will begin prototyping the wireframes today and share an update tomorrow.', DATE_SUB(NOW(), INTERVAL 15 MINUTE), TRUE);

