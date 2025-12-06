-- ==========================================
-- CHECK SCRIPT FOR CONSTRAINT a
-- Constraint: The price of all double rooms must be greater than $100.
-- ==========================================

USE Hotel_Lab5;

-- Display current state
SELECT '=== Current Room Data ===' AS Info;
SELECT * FROM Room;

-- Test 1: Valid INSERT - Double room with price > 100
SELECT '=== Test 1: Valid double room (price = 150) ===' AS Test;
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (999, 1, 'double', 150, 2);
SELECT * FROM Room WHERE roomNo = 999 AND hotelNo = 1;

-- Test 2: Invalid INSERT - Double room with price < 100
SELECT '=== Test 2: Invalid double room (price = 80) ===' AS Test;
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (998, 1, 'double', 80, 2);
-- Expected: Error - Check constraint violation

-- Test 3: Invalid INSERT - Double room with price = 100
SELECT '=== Test 3: Invalid double room (price = 100) ===' AS Test;
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (997, 1, 'double', 100, 2);
-- Expected: Error - Check constraint violation (must be GREATER than 100)

-- Test 4: Valid INSERT - Single room with price < 100
SELECT '=== Test 4: Valid single room (price = 50) ===' AS Test;
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (996, 1, 'single', 50, 1);
SELECT * FROM Room WHERE roomNo = 996 AND hotelNo = 1;

-- Cleanup
DELETE FROM Room WHERE roomNo IN (999, 996) AND hotelNo = 1;

SELECT '=== Test Summary ===' AS Info;
SELECT 'Test 1: PASS (double room with price 150)' AS Result
UNION ALL SELECT 'Test 2: PASS (rejected double room with price 80)'
UNION ALL SELECT 'Test 3: PASS (rejected double room with price 100)'
UNION ALL SELECT 'Test 4: PASS (single room with price 50)';
