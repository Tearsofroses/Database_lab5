-- ==========================================
-- CHECK SCRIPT: Constraint (a) - Room Price Between $10 and $100
-- Database: Hotel_Lab5
-- ==========================================

USE Hotel_Lab5;

-- -----------------------------------------
-- View Current Rooms
-- -----------------------------------------
SELECT * FROM Room;

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

-- Verify insertion
SELECT * FROM Room WHERE roomNo = 303;

-- Cleanup
DELETE FROM Room WHERE roomNo IN (301, 302, 303);
