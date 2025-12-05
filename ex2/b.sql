-- ==========================================
-- CONSTRAINT b: In a hotel, the price of double rooms must be greater than 
--               the price of the highest single room.
-- ==========================================

USE Hotel_Lab5;

DROP TRIGGER IF EXISTS trg_double_greater_single_insert;
DELIMITER //
CREATE TRIGGER trg_double_greater_single_insert
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    DECLARE max_single_price DECIMAL(10, 2);
    
    IF NEW.type = 'double' THEN
        SELECT IFNULL(MAX(price), 0) INTO max_single_price 
        FROM Room 
        WHERE hotelNo = NEW.hotelNo AND type = 'single';
        
        IF NEW.price <= max_single_price THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Double room price must be greater than highest single room price in the hotel.';
        END IF;
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_double_greater_single_update;
DELIMITER //
CREATE TRIGGER trg_double_greater_single_update
BEFORE UPDATE ON Room
FOR EACH ROW
BEGIN
    DECLARE max_single_price DECIMAL(10, 2);
    
    IF NEW.type = 'double' THEN
        SELECT IFNULL(MAX(price), 0) INTO max_single_price 
        FROM Room 
        WHERE hotelNo = NEW.hotelNo AND type = 'single' AND roomNo != NEW.roomNo;
        
        IF NEW.price <= max_single_price THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Double room price must be greater than highest single room price in the hotel.';
        END IF;
    END IF;
END //
DELIMITER ;
