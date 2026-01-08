-- Create database
CREATE DATABASE IF NOT EXISTS flightdb;
USE flightdb;

-- USERS TABLE
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    gender VARCHAR(10),
    contactNumber VARCHAR(15),
    age INT
);

-- USER ROLES TABLE
CREATE TABLE user_roles (
    user_id BIGINT NOT NULL,
    role VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id, role),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- FLIGHT TABLE
CREATE TABLE flight (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    flightNumber VARCHAR(50) NOT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    departureDate DATE NOT NULL,
    departureTime DATETIME NOT NULL
);

-- BOOKING TABLE
CREATE TABLE booking (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    flight_id BIGINT,
    booking_date DATE NOT NULL,
    seat_number VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES flight(id) ON DELETE CASCADE
);

-- INDEXES
CREATE INDEX idx_user_id ON booking(user_id);
CREATE INDEX idx_flight_id ON booking(flight_id);

-- FLIGHT DATA
INSERT INTO flight (flightNumber, origin, destination, departureDate, departureTime) VALUES
('AI101', 'Mumbai', 'Delhi', '2024-11-20', '2024-11-20 06:30:00'),
('6E202', 'Bangalore', 'Chennai', '2024-11-21', '2024-11-21 09:00:00'),
('SG303', 'Hyderabad', 'Kolkata', '2024-11-22', '2024-11-22 14:30:00'),
('AI404', 'Jaipur', 'Pune', '2024-11-23', '2024-11-23 18:00:00'),
('6E505', 'Delhi', 'Goa', '2024-11-24', '2024-11-24 12:45:00'),
('AI606', 'Chennai', 'Mumbai', '2024-11-25', '2024-11-25 20:30:00'),
('SG707', 'Kolkata', 'Ahmedabad', '2024-11-26', '2024-11-26 07:15:00'),
('AI808', 'Pune', 'Jaipur', '2024-11-27', '2024-11-27 13:30:00'),
('6E909', 'Goa', 'Hyderabad', '2024-11-28', '2024-11-28 17:00:00'),
('SG010', 'Ahmedabad', 'Bangalore', '2024-11-29', '2024-11-29 21:45:00');

-- CHECK-IN TABLE
CREATE TABLE check_in (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    number_of_bags VARCHAR(255),
    check_in_time DATETIME,
    FOREIGN KEY (booking_id) REFERENCES booking(id) ON DELETE CASCADE
);

