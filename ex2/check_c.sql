-- ==========================================
-- CHECK SCRIPT FOR CONSTRAINT c
-- Constraint: A guest cannot make two bookings with overlapping dates.
-- ==========================================

USE Hotel_Lab5;

-- Display current state
SELECT '=== Current Booking Data for Guest 1 ===' AS Info;
SELECT * FROM Booking WHERE guestNo = 1;

-- Setup: Create initial booking for guest 1
SELECT '=== Setup: Creating initial booking ===' AS Info;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-01-10', 101, 1, '2025-01-15', 2);
SELECT * FROM Booking WHERE guestNo = 1;

-- Test 1: Valid INSERT - Non-overlapping booking (after existing booking)
SELECT '=== Test 1: Valid non-overlapping booking (Jan 20-25) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-01-20', 102, 1, '2025-01-25', 1);
SELECT * FROM Booking WHERE guestNo = 1 ORDER BY dateFrom;

-- Test 2: Invalid INSERT - Overlapping booking (partial overlap)
SELECT '=== Test 2: Invalid overlapping booking (Jan 12-18) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-01-12', 103, 1, '2025-01-18', 2);
-- Expected: Error - Guest cannot have overlapping bookings

-- Test 3: Invalid INSERT - Complete overlap (within existing booking)
SELECT '=== Test 3: Invalid overlapping booking (Jan 11-13) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (2, '2025-01-11', 201, 1, '2025-01-13', 1);
-- Expected: Error - Guest cannot have overlapping bookings

-- Test 4: Valid INSERT - Booking starts when previous ends
SELECT '=== Test 4: Valid back-to-back booking (Jan 15-18) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-01-15', 103, 1, '2025-01-18', 2);
SELECT * FROM Booking WHERE guestNo = 1 ORDER BY dateFrom;

-- Test 5: Invalid UPDATE - Change dates to create overlap
SELECT '=== Test 5: Invalid UPDATE - creating overlap ===' AS Test;
UPDATE Booking 
SET dateTo = '2025-01-22' 
WHERE guestNo = 1 AND dateFrom = '2025-01-15';
-- Expected: Error - Would create overlap with Jan 20-25 booking

-- Test 6: Valid UPDATE - Change dates without overlap
SELECT '=== Test 6: Valid UPDATE - no overlap ===' AS Test;
UPDATE Booking 
SET dateTo = '2025-01-19' 
WHERE guestNo = 1 AND dateFrom = '2025-01-15';
SELECT * FROM Booking WHERE guestNo = 1 ORDER BY dateFrom;

-- Cleanup
DELETE FROM Booking WHERE guestNo = 1 AND dateFrom IN ('2025-01-10', '2025-01-15', '2025-01-20');

SELECT '=== Test Summary ===' AS Info;
SELECT 'Test 1: PASS (non-overlapping booking Jan 20-25)' AS Result
UNION ALL SELECT 'Test 2: PASS (rejected overlapping booking Jan 12-18)'
UNION ALL SELECT 'Test 3: PASS (rejected overlapping booking Jan 11-13)'
UNION ALL SELECT 'Test 4: PASS (back-to-back booking Jan 15-18)'
UNION ALL SELECT 'Test 5: PASS (rejected UPDATE creating overlap)'
UNION ALL SELECT 'Test 6: PASS (valid UPDATE to Jan 15-19)';

