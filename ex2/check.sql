-- ==========================================
-- LAB 5: EXERCISE 2 - CHECK SCRIPT
-- Database: Hotel_Lab5
-- ==========================================

USE Hotel_Lab5;

-- -----------------------------------------
-- View Database Tables
-- -----------------------------------------
SELECT * FROM Hotel;
SELECT * FROM Room;
SELECT * FROM Guest;
SELECT * FROM Booking;

-- -----------------------------------------
-- Test Constraint (a) - Room Price Between $10 and $100
-- -----------------------------------------
-- Test 1: Try to insert room with price < 10 (should fail)
INSERT INTO Room VALUES (301, 1, 'Single', 5);
-- Result: Check constraint violated

-- Test 2: Try to insert room with price > 100 (should fail)
INSERT INTO Room VALUES (302, 1, 'Suite', 150);
-- Result: Check constraint violated

-- Test 3: Insert room with valid price (should succeed)
INSERT INTO Room VALUES (303, 1, 'Double', 50);
-- Result: Row inserted

-- Cleanup
DELETE FROM Room WHERE roomNo IN (301, 302, 303);

-- -----------------------------------------
-- Test Constraint (b) - Booking Duration <= 14 Days
-- -----------------------------------------
-- Test 1: Try to insert booking for 15 days (should fail)
INSERT INTO Booking VALUES 
    (1, 1, '2024-01-01', '2024-01-16', 101);
-- Result: Check constraint violated

-- Test 2: Insert booking for exactly 14 days (should succeed)
INSERT INTO Booking VALUES 
    (1, 2, '2024-02-01', '2024-02-15', 102);
-- Result: Row inserted

-- Test 3: Insert booking for 7 days (should succeed)
INSERT INTO Booking VALUES 
    (1, 3, '2024-03-01', '2024-03-08', 103);
-- Result: Row inserted

-- Cleanup
DELETE FROM Booking WHERE (hotelNo = 1 AND dateFrom IN ('2024-01-01', '2024-02-01', '2024-03-01'));

-- -----------------------------------------
-- Test Constraint (c) - No Double Booking
-- -----------------------------------------
-- Setup: Insert initial booking
INSERT INTO Booking VALUES 
    (1, 1, '2024-04-10', '2024-04-15', 101);
-- Result: Row inserted

-- Test 1: Try overlapping booking (should fail)
INSERT INTO Booking VALUES 
    (1, 2, '2024-04-12', '2024-04-18', 101);
-- Result: Trigger error - overlap

-- Test 2: Non-overlapping booking (should succeed)
INSERT INTO Booking VALUES 
    (1, 2, '2024-04-20', '2024-04-25', 101);
-- Result: Row inserted

-- Cleanup
DELETE FROM Booking WHERE hotelNo = 1 AND roomNo = 101 AND dateFrom IN ('2024-04-10', '2024-04-20');

-- -----------------------------------------
-- Test Constraint (d) - Maximum Grosvenor Bookings
-- -----------------------------------------
-- Setup: Insert Grosvenor hotel
INSERT INTO Hotel VALUES (10, 'Grosvenor', 'London');
INSERT INTO Room VALUES (101, 10, 'Single', 50);
INSERT INTO Guest VALUES (1, 'Test Guest', '123 Test St');

-- Insert 10 bookings for guest 1 at Grosvenor
INSERT INTO Booking VALUES (10, 1, '2024-01-01', '2024-01-05', 101);
INSERT INTO Booking VALUES (10, 1, '2024-01-06', '2024-01-10', 101);
INSERT INTO Booking VALUES (10, 1, '2024-01-11', '2024-01-15', 101);
INSERT INTO Booking VALUES (10, 1, '2024-01-16', '2024-01-20', 101);
INSERT INTO Booking VALUES (10, 1, '2024-01-21', '2024-01-25', 101);
INSERT INTO Booking VALUES (10, 1, '2024-02-01', '2024-02-05', 101);
INSERT INTO Booking VALUES (10, 1, '2024-02-06', '2024-02-10', 101);
INSERT INTO Booking VALUES (10, 1, '2024-02-11', '2024-02-15', 101);
INSERT INTO Booking VALUES (10, 1, '2024-02-16', '2024-02-20', 101);
INSERT INTO Booking VALUES (10, 1, '2024-02-21', '2024-02-25', 101);

-- Test: Try to insert 11th booking (should fail)
INSERT INTO Booking VALUES 
    (10, 1, '2024-12-01', '2024-12-05', 101);
-- Result: Error - Guest cannot make more than 10 bookings for Grosvenor hotel

-- Cleanup
DELETE FROM Booking WHERE hotelNo = 10;
DELETE FROM Room WHERE hotelNo = 10;
DELETE FROM Hotel WHERE hotelNo = 10;
DELETE FROM Guest WHERE guestNo = 1;

-- -----------------------------------------
-- Test Constraint (e) - London Room Price Increase <= 10%
-- -----------------------------------------
-- Setup: London hotel and room
INSERT INTO Hotel VALUES (20, 'Royal', 'London');
INSERT INTO Room VALUES (201, 20, 'Double', 80);
-- Result: Row inserted

-- Test 1: Try to increase price by 15% (should fail)
UPDATE Room SET price = 92 WHERE roomNo = 201 AND hotelNo = 20;
-- Result: Trigger error

-- Test 2: Increase price by 10% (should succeed)
UPDATE Room SET price = 88 WHERE roomNo = 201 AND hotelNo = 20;
-- Result: Row updated

-- Cleanup
DELETE FROM Room WHERE hotelNo = 20;
DELETE FROM Hotel WHERE hotelNo = 20;

-- -----------------------------------------
-- Test Constraint (f) - No Direct Deletes from Hotel Table
-- -----------------------------------------
-- Setup: Insert a test hotel
INSERT INTO Hotel VALUES (99, 'Test Hotel', 'Test City');
-- Result: Row inserted

-- Test 1: Try direct delete (should fail)
DELETE FROM Hotel WHERE hotelNo = 99;
-- Result: Trigger error

-- Test 2: Delete through view procedure (should succeed)
CALL DeleteFromVhotel1(99);
-- Result: Row deleted
-- ==========================================

-- View current London hotels
SELECT * FROM LondonHotelRoom;

-- Insert new hotel and room via procedure
CALL InsertIntoLondonHotelRoom(10, 'Test London Hotel', 1, 'double', 200.00);

-- Verify hotel was created with city = 'London'
SELECT * FROM Hotel WHERE hotelNo = 10;

-- Verify room was created
SELECT * FROM Room WHERE hotelNo = 10;

-- Verify it appears in the view
SELECT * FROM LondonHotelRoom WHERE hotelNo = 10;

-- Add another room to the same hotel
CALL InsertIntoLondonHotelRoom(10, 'Test London Hotel', 2, 'single', 100.00);
SELECT * FROM LondonHotelRoom WHERE hotelNo = 10;

-- Clean up test data
DELETE FROM Room WHERE hotelNo = 10;
DELETE FROM Hotel WHERE hotelNo = 10;

-- Final verification
SELECT * FROM Guest;
