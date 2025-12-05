-- ==========================================
-- CONSTRAINT c: A guest cannot make two bookings with overlapping dates.
-- ==========================================

USE Hotel_Lab5;

DROP TRIGGER IF EXISTS trg_no_overlapping_bookings_insert;
DELIMITER //
CREATE TRIGGER trg_no_overlapping_bookings_insert
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    
    SELECT COUNT(*) INTO overlap_count
    FROM Booking
    WHERE guestNo = NEW.guestNo
      AND NOT (NEW.dateTo <= dateFrom OR NEW.dateFrom >= dateTo);
    
    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Guest cannot have overlapping bookings.';
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_no_overlapping_bookings_update;
DELIMITER //
CREATE TRIGGER trg_no_overlapping_bookings_update
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    
    SELECT COUNT(*) INTO overlap_count
    FROM Booking
    WHERE guestNo = NEW.guestNo
      AND NOT (hotelNo = OLD.hotelNo AND dateFrom = OLD.dateFrom AND roomNo = OLD.roomNo)
      AND NOT (NEW.dateTo <= dateFrom OR NEW.dateFrom >= dateTo);
    
    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Guest cannot have overlapping bookings.';
    END IF;
END //
DELIMITER ;
