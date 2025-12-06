-- ==========================================
-- CHECK SCRIPT: Constraint (d) - Maximum Grosvenor Bookings
-- Database: Hotel_Lab5
-- ==========================================

USE Hotel_Lab5;

-- -----------------------------------------
-- Setup: Create Grosvenor hotel and guest
-- -----------------------------------------
INSERT INTO Hotel VALUES (10, 'Grosvenor', 'London');
INSERT INTO Room VALUES (101, 10, 'Single', 50);
INSERT INTO Guest VALUES (1, 'Test Guest', '123 Test St');

-- Verify setup
SELECT * FROM Hotel WHERE hotelNo = 10;
SELECT * FROM Room WHERE hotelNo = 10;
SELECT * FROM Guest WHERE guestNo = 1;

-- -----------------------------------------
-- Test Constraint (d) - Maximum Grosvenor Bookings
-- -----------------------------------------
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

-- Verify 10 bookings exist
SELECT COUNT(*) AS Booking_Count FROM Booking WHERE hotelNo = 10 AND guestNo = 1;

-- Test: Try to insert 11th booking (should fail)
INSERT INTO Booking VALUES 
    (10, 1, '2024-12-01', '2024-12-05', 101);
-- Result: Error - Guest cannot make more than 10 bookings for Grosvenor hotel

-- Cleanup
DELETE FROM Booking WHERE hotelNo = 10;
DELETE FROM Room WHERE hotelNo = 10;
DELETE FROM Hotel WHERE hotelNo = 10;
DELETE FROM Guest WHERE guestNo = 1;
