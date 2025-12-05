-- ==========================================
-- LAB 5: EXERCISE 2 - VALIDATION / CHECK SCRIPT
-- ==========================================

USE Hotel_Lab5;

-- ==========================================
-- VIEW DATA
-- ==========================================

-- Hotel Data
SELECT * FROM Hotel;

-- Room Data
SELECT * FROM Room;

-- Guest Data
SELECT * FROM Guest;

-- Booking Data
SELECT * FROM Booking;

-- LondonHotelRoom View
SELECT * FROM LondonHotelRoom;

-- ==========================================
-- TEST CONSTRAINT a: Double room price > $100
-- ==========================================

-- Should FAIL: Double room with price <= 100
-- INSERT INTO Room VALUES (10, 1, 'double', 90.00, 2);

-- Should SUCCEED: Double room with price > 100
INSERT INTO Room VALUES (10, 1, 'double', 150.00, 2);
SELECT * FROM Room WHERE roomNo = 10 AND hotelNo = 1;
DELETE FROM Room WHERE roomNo = 10 AND hotelNo = 1;

-- ==========================================
-- TEST CONSTRAINT b: Double room > highest single room
-- ==========================================

-- Check highest single room price in hotel 1
SELECT MAX(price) AS max_single_price FROM Room WHERE hotelNo = 1 AND type = 'single';

-- Should FAIL: Double room price <= highest single (80)
-- INSERT INTO Room VALUES (10, 1, 'double', 75.00, 2);

-- Should SUCCEED: Double room price > highest single
INSERT INTO Room VALUES (10, 1, 'double', 120.00, 2);
SELECT * FROM Room WHERE roomNo = 10 AND hotelNo = 1;
DELETE FROM Room WHERE roomNo = 10 AND hotelNo = 1;

-- ==========================================
-- TEST CONSTRAINT c: No overlapping bookings
-- ==========================================

-- Check existing booking for guest 101 (2024-01-01 to 2024-01-05)
SELECT * FROM Booking WHERE guestNo = 101;

-- Should FAIL: Overlapping dates (2024-01-03 overlaps with existing)
-- INSERT INTO Booking VALUES (2, '2024-01-03', 1, 101, '2024-01-08', 1);

-- Should SUCCEED: Non-overlapping dates
INSERT INTO Booking VALUES (2, '2024-01-10', 1, 101, '2024-01-15', 1);
SELECT * FROM Booking WHERE guestNo = 101;
DELETE FROM Booking WHERE hotelNo = 2 AND dateFrom = '2024-01-10' AND roomNo = 1;

-- ==========================================
-- TEST CONSTRAINT d: NumOfAdult <= NumAdultMax
-- ==========================================

-- Check room capacity for room 1 in hotel 1 (single room, NumAdultMax = 1)
SELECT roomNo, type, NumAdultMax FROM Room WHERE roomNo = 1 AND hotelNo = 1;

-- Should FAIL: NumOfAdult (3) > NumAdultMax (1)
-- INSERT INTO Booking VALUES (1, '2024-06-01', 1, 103, '2024-06-05', 3);

-- Should SUCCEED: NumOfAdult <= NumAdultMax
INSERT INTO Booking VALUES (1, '2024-06-01', 1, 103, '2024-06-05', 1);
SELECT * FROM Booking WHERE hotelNo = 1 AND dateFrom = '2024-06-01';
DELETE FROM Booking WHERE hotelNo = 1 AND dateFrom = '2024-06-01' AND roomNo = 1;

-- ==========================================
-- TEST CONSTRAINT e: Auto-calculate TotalAmount
-- ==========================================

-- Check initial TotalAmount
SELECT guestNo, guestName, TotalAmount FROM Guest;

-- Insert new booking and check TotalAmount updates
-- Room 2 in hotel 3 costs 120/night, 5 nights = 600
INSERT INTO Booking VALUES (3, '2024-05-01', 2, 103, '2024-05-06', 2);
SELECT guestNo, guestName, TotalAmount FROM Guest WHERE guestNo = 103;

-- Delete the booking and verify TotalAmount decreases
DELETE FROM Booking WHERE hotelNo = 3 AND dateFrom = '2024-05-01' AND roomNo = 2;
SELECT guestNo, guestName, TotalAmount FROM Guest WHERE guestNo = 103;

-- ==========================================
-- TEST CONSTRAINT f: InsertIntoLondonHotelRoom procedure
-- ==========================================

-- View current London hotels
SELECT * FROM LondonHotelRoom;

-- Insert new hotel and room via procedure
CALL InsertIntoLondonHotelRoom(10, 'Test London Hotel', 1, 'double', 200.00);

-- Verify hotel was created with city = 'London'
SELECT * FROM Hotel WHERE hotelNo = 10;

-- Verify room was created
SELECT * FROM Room WHERE hotelNo = 10;

-- Verify it appears in the view
SELECT * FROM LondonHotelRoom WHERE hotelNo = 10;

-- Add another room to the same hotel
CALL InsertIntoLondonHotelRoom(10, 'Test London Hotel', 2, 'single', 100.00);
SELECT * FROM LondonHotelRoom WHERE hotelNo = 10;

-- Clean up test data
DELETE FROM Room WHERE hotelNo = 10;
DELETE FROM Hotel WHERE hotelNo = 10;

-- Final verification
SELECT * FROM Guest;
