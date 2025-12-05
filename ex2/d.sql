-- ==========================================
-- CONSTRAINT d: A guest cannot make a booking with number of adults greater 
--               than NumAdultMax value of booked room.
-- ==========================================

USE Hotel_Lab5;

DROP TRIGGER IF EXISTS trg_check_num_adults_insert;
DELIMITER //
CREATE TRIGGER trg_check_num_adults_insert
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE max_adults INT;
    
    SELECT NumAdultMax INTO max_adults 
    FROM Room 
    WHERE roomNo = NEW.roomNo AND hotelNo = NEW.hotelNo;
    
    IF NEW.NumOfAdult > max_adults THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Number of adults exceeds room capacity.';
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_check_num_adults_update;
DELIMITER //
CREATE TRIGGER trg_check_num_adults_update
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
    DECLARE max_adults INT;
    
    SELECT NumAdultMax INTO max_adults 
    FROM Room 
    WHERE roomNo = NEW.roomNo AND hotelNo = NEW.hotelNo;
    
    IF NEW.NumOfAdult > max_adults THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Number of adults exceeds room capacity.';
    END IF;
END //
DELIMITER ;
