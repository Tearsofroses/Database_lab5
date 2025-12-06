-- ==========================================
-- CONSTRAINT f: Create an INSTEAD OF database trigger that will allow data 
--               to be inserted into the LondonHotelRoom view.
-- ==========================================
-- Note: INSTEAD OF triggers are supported in SQL Server, PostgreSQL, and Oracle
--       but NOT in MySQL. This script uses standard SQL Server/PostgreSQL syntax.

-- First, create the view
DROP VIEW IF EXISTS LondonHotelRoom;
CREATE VIEW LondonHotelRoom AS
SELECT h.hotelNo, hotelName, city, roomNo, type, price
FROM Hotel h, Room r
WHERE h.hotelNo = r.hotelNo AND city = 'London';

-- ==========================================
-- SQL Server Syntax for INSTEAD OF Trigger
-- ==========================================
/*
CREATE TRIGGER trg_instead_of_insert_LondonHotelRoom
ON LondonHotelRoom
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @hotelNo INT, @hotelName VARCHAR(50), @roomNo INT, 
            @type VARCHAR(20), @price DECIMAL(10,2);
    
    -- Get values from the inserted pseudo-table
    SELECT @hotelNo = hotelNo, @hotelName = hotelName, 
           @roomNo = roomNo, @type = type, @price = price
    FROM inserted;
    
    -- Check if hotel exists
    IF NOT EXISTS (SELECT 1 FROM Hotel WHERE hotelNo = @hotelNo)
    BEGIN
        -- Insert new hotel with city = 'London'
        INSERT INTO Hotel (hotelNo, hotelName, city)
        VALUES (@hotelNo, @hotelName, 'London');
    END
    ELSE
    BEGIN
        -- Update hotel name if exists
        UPDATE Hotel SET hotelName = @hotelName WHERE hotelNo = @hotelNo;
    END
    
    -- Insert the room
    INSERT INTO Room (roomNo, hotelNo, type, price)
    VALUES (@roomNo, @hotelNo, @type, @price);
END;
GO
*/

-- ==========================================
-- PostgreSQL Syntax for INSTEAD OF Trigger
-- ==========================================
/*
-- First create the trigger function
CREATE OR REPLACE FUNCTION fn_instead_of_insert_LondonHotelRoom()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if hotel exists
    IF NOT EXISTS (SELECT 1 FROM Hotel WHERE hotelNo = NEW.hotelNo) THEN
        -- Insert new hotel with city = 'London'
        INSERT INTO Hotel (hotelNo, hotelName, city)
        VALUES (NEW.hotelNo, NEW.hotelName, 'London');
    ELSE
        -- Update hotel name if exists
        UPDATE Hotel SET hotelName = NEW.hotelName WHERE hotelNo = NEW.hotelNo;
    END IF;
    
    -- Insert the room
    INSERT INTO Room (roomNo, hotelNo, type, price)
    VALUES (NEW.roomNo, NEW.hotelNo, NEW.type, NEW.price);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the INSTEAD OF trigger on the view
CREATE TRIGGER trg_instead_of_insert_LondonHotelRoom
INSTEAD OF INSERT ON LondonHotelRoom
FOR EACH ROW
EXECUTE FUNCTION fn_instead_of_insert_LondonHotelRoom();
*/

-- ==========================================
-- Oracle Syntax for INSTEAD OF Trigger
-- ==========================================
CREATE OR REPLACE TRIGGER trg_instead_of_insert_LondonHotelRoom
INSTEAD OF INSERT ON LondonHotelRoom
FOR EACH ROW
DECLARE
    v_hotel_count INT;
BEGIN
    -- Check if hotel exists
    SELECT COUNT(*) INTO v_hotel_count 
    FROM Hotel WHERE hotelNo = :NEW.hotelNo;
    
    IF v_hotel_count = 0 THEN
        -- Insert new hotel with city = 'London'
        INSERT INTO Hotel (hotelNo, hotelName, city)
        VALUES (:NEW.hotelNo, :NEW.hotelName, 'London');
    ELSE
        -- Update hotel name if exists
        UPDATE Hotel SET hotelName = :NEW.hotelName 
        WHERE hotelNo = :NEW.hotelNo;
    END IF;
    
    -- Insert the room
    INSERT INTO Room (roomNo, hotelNo, type, price)
    VALUES (:NEW.roomNo, :NEW.hotelNo, :NEW.type, :NEW.price);
END;
/

-- ==========================================
-- Test the INSTEAD OF trigger
-- ==========================================
-- Insert into the view (will be handled by the INSTEAD OF trigger)
INSERT INTO LondonHotelRoom (hotelNo, hotelName, city, roomNo, type, price)
VALUES (10, 'Royal Palace Hotel', 'London', 501, 'double', 250.00);

-- Verify the data was inserted into base tables
SELECT * FROM Hotel WHERE hotelNo = 10;
SELECT * FROM Room WHERE hotelNo = 10;

-- Query the view to see the result
SELECT * FROM LondonHotelRoom WHERE hotelNo = 10;
