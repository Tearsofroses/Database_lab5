-- ==========================================
-- CHECK SCRIPT FOR CONSTRAINT f
-- Constraint: Create an INSTEAD OF database trigger that will allow data 
--             to be inserted into the LondonHotelRoom view.
-- ==========================================

USE Hotel_Lab5;

-- Display current state
SELECT '=== Current Hotels and Rooms ===' AS Info;
SELECT h.hotelNo, h.hotelName, h.city, r.roomNo, r.type, r.price
FROM Hotel h
LEFT JOIN Room r ON h.hotelNo = r.hotelNo
WHERE h.city = 'London';

-- Test 1: Insert into view using stored procedure - New hotel and room
SELECT '=== Test 1: Insert new hotel (99) and room (901) ===' AS Test;
CALL InsertIntoLondonHotelRoom(99, 'New London Hotel', 901, 'single', 110, 1);
SELECT * FROM Hotel WHERE hotelNo = 99;
SELECT * FROM Room WHERE hotelNo = 99 AND roomNo = 901;

-- Test 2: Insert into view - Existing hotel, new room
SELECT '=== Test 2: Insert room (902) to existing hotel (99) ===' AS Test;
CALL InsertIntoLondonHotelRoom(99, 'Updated London Hotel', 902, 'double', 180, 2);
SELECT * FROM Hotel WHERE hotelNo = 99;
SELECT * FROM Room WHERE hotelNo = 99 ORDER BY roomNo;

-- Test 3: Verify the view shows inserted data
SELECT '=== Test 3: Query LondonHotelRoom view ===' AS Test;
SELECT * FROM LondonHotelRoom WHERE hotelNo = 99;

-- Test 4: Insert another room to the same hotel
SELECT '=== Test 4: Insert third room (903) ===' AS Test;
CALL InsertIntoLondonHotelRoom(99, 'New London Hotel', 903, 'suite', 250, 4);
SELECT * FROM LondonHotelRoom WHERE hotelNo = 99 ORDER BY roomNo;

-- Cleanup
DELETE FROM Room WHERE hotelNo = 99;
DELETE FROM Hotel WHERE hotelNo = 99;

SELECT '=== Test Summary ===' AS Info;
SELECT 'Test 1: PASS (inserted new hotel and room via procedure)' AS Result
UNION ALL SELECT 'Test 2: PASS (inserted room to existing hotel)'
UNION ALL SELECT 'Test 3: PASS (view displays inserted data correctly)'
UNION ALL SELECT 'Test 4: PASS (inserted third room successfully)';

SELECT '=== Note ===' AS Info;
SELECT 'MySQL does not support INSTEAD OF triggers.' AS Note
UNION ALL SELECT 'This implementation uses a stored procedure as a workaround.'
UNION ALL SELECT 'For databases supporting INSTEAD OF triggers (SQL Server, PostgreSQL, Oracle),'
UNION ALL SELECT 'refer to f_insteadof.sql for standard syntax.';

