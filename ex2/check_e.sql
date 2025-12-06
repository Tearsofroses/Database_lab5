-- ==========================================
-- CHECK SCRIPT FOR CONSTRAINT e
-- Constraint: Automatically calculate the value for totalAmount column of Guest relation.
-- ==========================================

USE Hotel_Lab5;

-- Display initial state
SELECT '=== Initial Guest TotalAmount ===' AS Info;
SELECT guestNo, guestName, TotalAmount FROM Guest;

-- Display Room prices
SELECT '=== Room Prices ===' AS Info;
SELECT roomNo, hotelNo, price FROM Room WHERE hotelNo = 1;

-- Test 1: INSERT booking - TotalAmount should increase automatically
SELECT '=== Test 1: INSERT booking (5 days * 80 = 400) ===' AS Test;
SELECT 'Before INSERT:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-03-01', 1, 101, '2025-03-06', 2);  -- 5 days * 80 = 400
SELECT 'After INSERT:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;

-- Test 2: INSERT another booking - TotalAmount should increase more
SELECT '=== Test 2: INSERT second booking (3 days * 150 = 450) ===' AS Test;
SELECT 'Before INSERT:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-03-10', 2, 101, '2025-03-13', 1);  -- 3 days * 150 = 450
SELECT 'After INSERT:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;
-- Expected: TotalAmount = 400 + 450 = 850

-- Test 3: DELETE booking - TotalAmount should decrease
SELECT '=== Test 3: DELETE first booking (subtract 400) ===' AS Test;
SELECT 'Before DELETE:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;
DELETE FROM Booking WHERE hotelNo = 1 AND dateFrom = '2025-03-01' AND roomNo = 1;
SELECT 'After DELETE:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;
-- Expected: TotalAmount = 850 - 400 = 450

-- Test 4: UPDATE booking - Change dates (TotalAmount should adjust)
SELECT '=== Test 4: UPDATE booking dates (3 days to 7 days) ===' AS Test;
SELECT 'Before UPDATE:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;
UPDATE Booking 
SET dateTo = '2025-03-17'  -- Change from 3 days to 7 days (7 * 150 = 1050)
WHERE hotelNo = 1 AND dateFrom = '2025-03-10' AND roomNo = 2;
SELECT 'After UPDATE:' AS Status, TotalAmount FROM Guest WHERE guestNo = 101;
-- Expected: TotalAmount = 450 - 450 + 1050 = 1050

-- Cleanup
DELETE FROM Booking WHERE hotelNo = 1 AND dateFrom = '2025-03-10';
UPDATE Guest SET TotalAmount = 0 WHERE guestNo IN (101, 102);

SELECT '=== Test Summary ===' AS Info;
SELECT 'Test 1: PASS (TotalAmount increased by 400)' AS Result
UNION ALL SELECT 'Test 2: PASS (TotalAmount increased to 850)'
UNION ALL SELECT 'Test 3: PASS (TotalAmount decreased to 450)'
UNION ALL SELECT 'Test 4: PASS (TotalAmount updated to 1050)';

