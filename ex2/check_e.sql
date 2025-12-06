-- ==========================================
-- CHECK SCRIPT: Constraint (e) - London Room Price Increase <= 10%
-- Database: Hotel_Lab5
-- ==========================================

USE Hotel_Lab5;

-- -----------------------------------------
-- Setup: London hotel and room
-- -----------------------------------------
INSERT INTO Hotel VALUES (20, 'Royal', 'London');
INSERT INTO Room VALUES (201, 20, 'Double', 80);

-- Verify setup
SELECT * FROM Hotel WHERE hotelNo = 20;
SELECT * FROM Room WHERE hotelNo = 20 AND roomNo = 201;

-- -----------------------------------------
-- Test Constraint (e) - London Room Price Increase <= 10%
-- -----------------------------------------
-- Test 1: Try to increase price by 15% (80 -> 92 = 15% increase) (should fail)
UPDATE Room SET price = 92 WHERE roomNo = 201 AND hotelNo = 20;
-- Result: Trigger error - Price increase for London hotels cannot exceed 10%

-- Verify price unchanged
SELECT roomNo, price FROM Room WHERE roomNo = 201 AND hotelNo = 20;

-- Test 2: Increase price by 10% (80 -> 88 = 10% increase) (should succeed)
UPDATE Room SET price = 88 WHERE roomNo = 201 AND hotelNo = 20;
-- Result: Row updated

-- Verify price updated
SELECT roomNo, price FROM Room WHERE roomNo = 201 AND hotelNo = 20;

-- Cleanup
DELETE FROM Room WHERE hotelNo = 20;
DELETE FROM Hotel WHERE hotelNo = 20;
