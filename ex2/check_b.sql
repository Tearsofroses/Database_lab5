-- ==========================================
-- CHECK SCRIPT: Constraint (b) - Booking Duration <= 14 Days
-- Database: Hotel_Lab5
-- ==========================================

USE Hotel_Lab5;

-- -----------------------------------------
-- View Current Bookings
-- -----------------------------------------
SELECT * FROM Booking;

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

-- Verify insertions
SELECT * FROM Booking WHERE hotelNo = 1 AND dateFrom IN ('2024-02-01', '2024-03-01');

-- Cleanup
DELETE FROM Booking WHERE (hotelNo = 1 AND dateFrom IN ('2024-01-01', '2024-02-01', '2024-03-01'));
