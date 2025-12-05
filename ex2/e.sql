-- ==========================================
-- CONSTRAINT e: Automatically calculate the value for totalAmount column of Guest relation.
-- ==========================================

USE Hotel_Lab5;

-- Trigger to update totalAmount when booking is inserted
DROP TRIGGER IF EXISTS trg_update_total_amount_insert;
DELIMITER //
CREATE TRIGGER trg_update_total_amount_insert
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE room_price DECIMAL(10, 2);
    DECLARE num_days INT;
    DECLARE booking_cost DECIMAL(12, 2);
    
    -- Get room price
    SELECT price INTO room_price FROM Room WHERE roomNo = NEW.roomNo AND hotelNo = NEW.hotelNo;
    
    -- Calculate number of days
    SET num_days = DATEDIFF(NEW.dateTo, NEW.dateFrom);
    
    -- Calculate booking cost
    SET booking_cost = room_price * num_days;
    
    -- Update guest's total amount
    UPDATE Guest 
    SET TotalAmount = TotalAmount + booking_cost 
    WHERE guestNo = NEW.guestNo;
END //
DELIMITER ;

-- Trigger to update totalAmount when booking is deleted
DROP TRIGGER IF EXISTS trg_update_total_amount_delete;
DELIMITER //
CREATE TRIGGER trg_update_total_amount_delete
AFTER DELETE ON Booking
FOR EACH ROW
BEGIN
    DECLARE room_price DECIMAL(10, 2);
    DECLARE num_days INT;
    DECLARE booking_cost DECIMAL(12, 2);
    
    -- Get room price
    SELECT price INTO room_price FROM Room WHERE roomNo = OLD.roomNo AND hotelNo = OLD.hotelNo;
    
    -- Calculate number of days
    SET num_days = DATEDIFF(OLD.dateTo, OLD.dateFrom);
    
    -- Calculate booking cost
    SET booking_cost = room_price * num_days;
    
    -- Update guest's total amount
    UPDATE Guest 
    SET TotalAmount = TotalAmount - booking_cost 
    WHERE guestNo = OLD.guestNo;
END //
DELIMITER ;

-- Trigger to update totalAmount when booking is updated
DROP TRIGGER IF EXISTS trg_update_total_amount_update;
DELIMITER //
CREATE TRIGGER trg_update_total_amount_update
AFTER UPDATE ON Booking
FOR EACH ROW
BEGIN
    DECLARE old_room_price DECIMAL(10, 2);
    DECLARE new_room_price DECIMAL(10, 2);
    DECLARE old_num_days INT;
    DECLARE new_num_days INT;
    DECLARE old_booking_cost DECIMAL(12, 2);
    DECLARE new_booking_cost DECIMAL(12, 2);
    
    -- Get old room price
    SELECT price INTO old_room_price FROM Room WHERE roomNo = OLD.roomNo AND hotelNo = OLD.hotelNo;
    -- Get new room price
    SELECT price INTO new_room_price FROM Room WHERE roomNo = NEW.roomNo AND hotelNo = NEW.hotelNo;
    
    -- Calculate number of days
    SET old_num_days = DATEDIFF(OLD.dateTo, OLD.dateFrom);
    SET new_num_days = DATEDIFF(NEW.dateTo, NEW.dateFrom);
    
    -- Calculate booking costs
    SET old_booking_cost = old_room_price * old_num_days;
    SET new_booking_cost = new_room_price * new_num_days;
    
    -- Update old guest's total amount (subtract old booking)
    UPDATE Guest 
    SET TotalAmount = TotalAmount - old_booking_cost 
    WHERE guestNo = OLD.guestNo;
    
    -- Update new guest's total amount (add new booking)
    UPDATE Guest 
    SET TotalAmount = TotalAmount + new_booking_cost 
    WHERE guestNo = NEW.guestNo;
END //
DELIMITER ;

-- Initialize TotalAmount based on existing bookings
UPDATE Guest g
SET TotalAmount = (
    SELECT IFNULL(SUM(r.price * DATEDIFF(b.dateTo, b.dateFrom)), 0)
    FROM Booking b
    JOIN Room r ON b.roomNo = r.roomNo AND b.hotelNo = r.hotelNo
    WHERE b.guestNo = g.guestNo
);
