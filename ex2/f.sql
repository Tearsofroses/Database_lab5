-- ==========================================
-- CONSTRAINT f: Create an INSTEAD OF database trigger that will allow data 
--               to be inserted into the LondonHotelRoom view.
-- ==========================================

USE Hotel_Lab5;

-- First, create the view
DROP VIEW IF EXISTS LondonHotelRoom;
CREATE VIEW LondonHotelRoom AS
SELECT h.hotelNo, hotelName, city, roomNo, type, price
FROM Hotel h, Room r
WHERE h.hotelNo = r.hotelNo AND city = 'London';

-- Note: MySQL does not support INSTEAD OF triggers directly.
-- Instead, we can use a stored procedure to handle insertions into the view.

-- In MySQL, we create a stored procedure to insert into the view
DROP PROCEDURE IF EXISTS InsertIntoLondonHotelRoom;
DELIMITER //
CREATE PROCEDURE InsertIntoLondonHotelRoom(
    IN p_hotelNo INT,
    IN p_hotelName VARCHAR(50),
    IN p_roomNo INT,
    IN p_type VARCHAR(20),
    IN p_price DECIMAL(10, 2),
    IN p_numAdultMax INT
)
BEGIN
    DECLARE hotel_exists INT;
    
    -- Check if hotel exists
    SELECT COUNT(*) INTO hotel_exists FROM Hotel WHERE hotelNo = p_hotelNo;
    
    IF hotel_exists = 0 THEN
        -- Insert new hotel (city is always London for this view)
        INSERT INTO Hotel (hotelNo, hotelName, city) 
        VALUES (p_hotelNo, p_hotelName, 'London');
    ELSE
        -- Update hotel name if it exists
        UPDATE Hotel SET hotelName = p_hotelName WHERE hotelNo = p_hotelNo;
    END IF;
    
    -- Insert room
    INSERT INTO Room (roomNo, hotelNo, type, price, NumAdultMax) 
    VALUES (p_roomNo, p_hotelNo, p_type, p_price, p_numAdultMax);
END //
DELIMITER ;
