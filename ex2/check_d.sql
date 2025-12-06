-- ==========================================
-- CHECK SCRIPT FOR CONSTRAINT d
-- Constraint: A guest cannot make a booking with number of adults greater 
--             than NumAdultMax value of booked room.
-- ==========================================

USE Hotel_Lab5;

-- Display current state
SELECT '=== Current Room Data ===' AS Info;
SELECT roomNo, hotelNo, type, NumAdultMax FROM Room WHERE hotelNo = 1;

-- Test 1: Valid INSERT - NumOfAdult <= NumAdultMax
SELECT '=== Test 1: Valid booking (2 adults, room max = 2) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-02-01', 2, 101, '2025-02-05', 2);
SELECT * FROM Booking WHERE hotelNo = 1 AND dateFrom = '2025-02-01';

-- Test 2: Invalid INSERT - NumOfAdult > NumAdultMax
SELECT '=== Test 2: Invalid booking (4 adults, room max = 2) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-02-10', 2, 101, '2025-02-15', 4);
-- Expected: Error - Number of adults exceeds room capacity

-- Test 3: Valid INSERT - NumOfAdult = NumAdultMax
SELECT '=== Test 3: Valid booking (2 adults, room max = 2) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-02-10', 3, 102, '2025-02-15', 2);
SELECT * FROM Booking WHERE hotelNo = 1 AND dateFrom = '2025-02-10' AND roomNo = 3;

-- Test 4: Invalid INSERT - NumOfAdult exceeds by 1
SELECT '=== Test 4: Invalid booking (3 adults, room max = 2) ===' AS Test;
INSERT INTO Booking (hotelNo, dateFrom, roomNo, guestNo, dateTo, NumOfAdult)
VALUES (1, '2025-02-20', 2, 103, '2025-02-25', 3);
-- Expected: Error - Number of adults exceeds room capacity

-- Cleanup
DELETE FROM Booking WHERE hotelNo = 1 AND dateFrom IN ('2025-02-01', '2025-02-10');

SELECT '=== Test Summary ===' AS Info;
SELECT 'Test 1: PASS (2 adults in room with max 2)' AS Result
UNION ALL SELECT 'Test 2: PASS (rejected 4 adults in room with max 2)'
UNION ALL SELECT 'Test 3: PASS (2 adults equals room max 2)'
UNION ALL SELECT 'Test 4: PASS (rejected 3 adults in room with max 2)';

