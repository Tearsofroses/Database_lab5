-- ==========================================
-- LAB 5: EXERCISE 2 - Hotel Database Schema
-- ==========================================

DROP DATABASE IF EXISTS Hotel_Lab5;
CREATE DATABASE Hotel_Lab5;
USE Hotel_Lab5;

-- ==========================================
-- TABLE CREATION
-- ==========================================

-- Hotel table
CREATE TABLE Hotel (
    hotelNo INT PRIMARY KEY,
    hotelName VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- Guest table
CREATE TABLE Guest (
    guestNo INT PRIMARY KEY,
    guestName VARCHAR(50) NOT NULL,
    guestAddress VARCHAR(100),
    TotalAmount DECIMAL(12, 2) DEFAULT 0
);

-- Room table
CREATE TABLE Room (
    roomNo INT,
    hotelNo INT,
    type VARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    NumAdultMax INT DEFAULT 2,
    PRIMARY KEY (roomNo, hotelNo),
    FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo)
);

-- Booking table
CREATE TABLE Booking (
    hotelNo INT,
    dateFrom DATE,
    roomNo INT,
    guestNo INT,
    dateTo DATE,
    NumOfAdult INT DEFAULT 1,
    PRIMARY KEY (hotelNo, dateFrom, roomNo),
    FOREIGN KEY (roomNo, hotelNo) REFERENCES Room(roomNo, hotelNo),
    FOREIGN KEY (guestNo) REFERENCES Guest(guestNo)
);

-- ==========================================
-- SAMPLE DATA INSERTION
-- ==========================================

-- Hotels
INSERT INTO Hotel VALUES 
(1, 'Grosvenor Hotel', 'London'),
(2, 'Ritz Hotel', 'Paris'),
(3, 'Marriott', 'New York'),
(4, 'Hilton', 'London');

-- Guests
INSERT INTO Guest (guestNo, guestName, guestAddress, TotalAmount) VALUES 
(101, 'John Smith', '123 Main St, London', 0),
(102, 'Jane Doe', '456 Oak Ave, Paris', 0),
(103, 'Bob Wilson', '789 Pine Rd, New York', 0),
(104, 'Alice Brown', '321 Elm St, London', 0);

-- Rooms
INSERT INTO Room VALUES 
(1, 1, 'single', 80.00, 1),
(2, 1, 'double', 150.00, 2),
(3, 1, 'double', 160.00, 3),
(1, 2, 'single', 90.00, 1),
(2, 2, 'double', 180.00, 2),
(1, 3, 'single', 70.00, 1),
(2, 3, 'double', 120.00, 2),
(1, 4, 'single', 85.00, 1),
(2, 4, 'double', 155.00, 2);

-- Bookings
INSERT INTO Booking VALUES 
(1, '2024-01-01', 1, 101, '2024-01-05', 1),
(1, '2024-01-10', 2, 102, '2024-01-15', 2),
(2, '2024-02-01', 1, 103, '2024-02-03', 1),
(3, '2024-03-01', 2, 104, '2024-03-07', 2);
