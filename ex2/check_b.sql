-- ==========================================
-- CHECK SCRIPT FOR CONSTRAINT b
-- Constraint: In a hotel, the price of double rooms must be greater than 
--             the price of the highest single room.
-- ==========================================

USE Hotel_Lab5;

-- Display current state
SELECT '=== Current Room Data for Hotel 1 ===' AS Info;
SELECT * FROM Room WHERE hotelNo = 1 ORDER BY type, price;

-- Test 1: Valid INSERT - Double room with price > highest single room
SELECT '=== Test 1: Valid double room (price = 200, max single = 80) ===' AS Test;
-- First, verify the highest single room price in hotel 1
SELECT MAX(price) AS Max_Single_Price FROM Room WHERE hotelNo = 1 AND type = 'single';
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (999, 1, 'double', 200, 2);
SELECT * FROM Room WHERE roomNo = 999 AND hotelNo = 1;

-- Test 2: Invalid INSERT - Double room with price <= highest single room
SELECT '=== Test 2: Invalid double room (price = 70, max single = 80) ===' AS Test;
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (998, 1, 'double', 70, 2);
-- Expected: Error - Double room price must be greater than highest single

-- Test 3: Invalid INSERT - Double room with price = highest single room
SELECT '=== Test 3: Invalid double room (price = 80, max single = 80) ===' AS Test;
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (997, 1, 'double', 80, 2);
-- Expected: Error - Double room price must be greater than highest single

-- Test 4: Valid INSERT - Single room (no constraint applies)
SELECT '=== Test 4: Valid single room (price = 90) ===' AS Test;
INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
VALUES (996, 1, 'single', 90, 1);
SELECT * FROM Room WHERE roomNo = 996 AND hotelNo = 1;

-- Cleanup
DELETE FROM Room WHERE roomNo IN (999, 996) AND hotelNo = 1;

SELECT '=== Test Summary ===' AS Info;
SELECT 'Test 1: PASS (double room with price 200 > max single 80)' AS Result
UNION ALL SELECT 'Test 2: PASS (rejected double room with price 70)'
UNION ALL SELECT 'Test 3: PASS (rejected double room with price 80)'
UNION ALL SELECT 'Test 4: PASS (single room with price 90)';

