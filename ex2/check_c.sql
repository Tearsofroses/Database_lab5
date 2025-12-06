-- ==========================================
-- CHECK SCRIPT: Constraint (c) - No Double Booking
-- Database: Hotel_Lab5
-- ==========================================

USE Hotel_Lab5;

-- -----------------------------------------
-- View Current Bookings for Room 101
-- -----------------------------------------
SELECT * FROM Booking WHERE roomNo = 101;

-- -----------------------------------------
-- Test Constraint (c) - No Double Booking
-- -----------------------------------------
-- Setup: Insert initial booking
INSERT INTO Booking VALUES 
    (1, 1, '2024-04-10', '2024-04-15', 101);
-- Result: Row inserted

-- Verify setup
SELECT * FROM Booking WHERE hotelNo = 1 AND roomNo = 101 AND dateFrom = '2024-04-10';

-- Test 1: Try overlapping booking (should fail)
INSERT INTO Booking VALUES 
    (1, 2, '2024-04-12', '2024-04-18', 101);
-- Result: Trigger error - overlap

-- Test 2: Non-overlapping booking (should succeed)
INSERT INTO Booking VALUES 
    (1, 2, '2024-04-20', '2024-04-25', 101);
-- Result: Row inserted

-- Verify non-overlapping booking
SELECT * FROM Booking WHERE hotelNo = 1 AND roomNo = 101 AND dateFrom = '2024-04-20';

-- Cleanup
DELETE FROM Booking WHERE hotelNo = 1 AND roomNo = 101 AND dateFrom IN ('2024-04-10', '2024-04-20');
