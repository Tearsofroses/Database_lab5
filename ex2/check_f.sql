-- ==========================================
-- CHECK SCRIPT: Constraint (f) - No Direct Deletes from Hotel Table
-- Database: Hotel_Lab5
-- ==========================================

USE Hotel_Lab5;

-- -----------------------------------------
-- Setup: Insert a test hotel
-- -----------------------------------------
INSERT INTO Hotel VALUES (99, 'Test Hotel', 'Test City');

-- Verify setup
SELECT * FROM Hotel WHERE hotelNo = 99;

-- -----------------------------------------
-- Test Constraint (f) - No Direct Deletes from Hotel Table
-- -----------------------------------------
-- Test 1: Try direct delete (should fail)
DELETE FROM Hotel WHERE hotelNo = 99;
-- Result: Trigger error - Direct deletion from Hotel table is not allowed

-- Verify hotel still exists
SELECT * FROM Hotel WHERE hotelNo = 99;

-- Test 2: Delete through view procedure (should succeed)
CALL DeleteFromVhotel1(99);
-- Result: Row deleted

-- Verify hotel deleted
SELECT * FROM Hotel WHERE hotelNo = 99;
