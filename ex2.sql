-- ==========================================
-- LAB 5: EXERCISE 2 - Hotel Database
-- ==========================================

DROP DATABASE IF EXISTS Hotel_Lab5;
CREATE DATABASE Hotel_Lab5;
USE Hotel_Lab5;

-- ==========================================
-- TABLE CREATION
-- ==========================================

-- Hotel table
CREATE TABLE Hotel (
    hotelNo INT PRIMARY KEY,
    hotelName VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- Guest table
CREATE TABLE Guest (
    guestNo INT PRIMARY KEY,
    guestName VARCHAR(50) NOT NULL,
    guestAddress VARCHAR(100),
    TotalAmount DECIMAL(12, 2) DEFAULT 0
);

-- Room table
CREATE TABLE Room (
    roomNo INT,
    hotelNo INT,
    type VARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    NumAdultMax INT DEFAULT 2,
    PRIMARY KEY (roomNo, hotelNo),
    FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo)
);

-- Booking table
CREATE TABLE Booking (
    hotelNo INT,
    dateFrom DATE,
    roomNo INT,
    guestNo INT,
    dateTo DATE,
    NumOfAdult INT DEFAULT 1,
    PRIMARY KEY (hotelNo, dateFrom, roomNo),
    FOREIGN KEY (hotelNo, roomNo) REFERENCES Room(roomNo, hotelNo),
    FOREIGN KEY (guestNo) REFERENCES Guest(guestNo)
);

-- ==========================================
-- SAMPLE DATA INSERTION
-- ==========================================

-- Hotels
INSERT INTO Hotel VALUES 
(1, 'Grosvenor Hotel', 'London'),
(2, 'Ritz Hotel', 'Paris'),
(3, 'Marriott', 'New York'),
(4, 'Hilton', 'London');

-- Guests
INSERT INTO Guest (guestNo, guestName, guestAddress, TotalAmount) VALUES 
(101, 'John Smith', '123 Main St, London', 0),
(102, 'Jane Doe', '456 Oak Ave, Paris', 0),
(103, 'Bob Wilson', '789 Pine Rd, New York', 0),
(104, 'Alice Brown', '321 Elm St, London', 0);

-- Rooms
INSERT INTO Room VALUES 
(1, 1, 'single', 80.00, 1),
(2, 1, 'double', 150.00, 2),
(3, 1, 'double', 160.00, 3),
(1, 2, 'single', 90.00, 1),
(2, 2, 'double', 180.00, 2),
(1, 3, 'single', 70.00, 1),
(2, 3, 'double', 120.00, 2),
(1, 4, 'single', 85.00, 1),
(2, 4, 'double', 155.00, 2);

-- Bookings
INSERT INTO Booking VALUES 
(1, '2024-01-01', 1, 101, '2024-01-05', 1),
(1, '2024-01-10', 2, 102, '2024-01-15', 2),
(2, '2024-02-01', 1, 103, '2024-02-03', 1),
(3, '2024-03-01', 2, 104, '2024-03-07', 2);

-- ==========================================
-- CONSTRAINT a: The price of all double rooms must be greater than $100.
-- ==========================================

-- Using CHECK constraint
ALTER TABLE Room 
ADD CONSTRAINT chk_double_room_price 
CHECK (type != 'double' OR price > 100);

-- Alternative: Using Trigger
DROP TRIGGER IF EXISTS trg_double_room_price_insert;
DELIMITER //
CREATE TRIGGER trg_double_room_price_insert
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    IF NEW.type = 'double' AND NEW.price <= 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Price of double rooms must be greater than $100.';
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_double_room_price_update;
DELIMITER //
CREATE TRIGGER trg_double_room_price_update
BEFORE UPDATE ON Room
FOR EACH ROW
BEGIN
    IF NEW.type = 'double' AND NEW.price <= 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Price of double rooms must be greater than $100.';
    END IF;
END //
DELIMITER ;

-- ==========================================
-- CONSTRAINT b: In a hotel, the price of double rooms must be greater than 
--               the price of the highest single room.
-- ==========================================

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

-- ==========================================
-- CONSTRAINT c: A guest cannot make two bookings with overlapping dates.
-- ==========================================

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

-- ==========================================
-- CONSTRAINT d: A guest cannot make a booking with number of adults greater 
--               than NumAdultMax value of booked room.
-- ==========================================

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

-- ==========================================
-- CONSTRAINT e: Automatically calculate the value for totalAmount column of Guest relation.
-- ==========================================

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

-- ==========================================
-- CONSTRAINT f: Create an INSTEAD OF database trigger that will allow data 
--               to be inserted into the LondonHotelRoom view.
-- ==========================================

-- First, create the view
DROP VIEW IF EXISTS LondonHotelRoom;
CREATE VIEW LondonHotelRoom AS
SELECT h.hotelNo, hotelName, city, roomNo, type, price
FROM Hotel h, Room r
WHERE h.hotelNo = r.hotelNo AND city = 'London';

-- Note: MySQL does not support INSTEAD OF triggers directly.
-- Instead, we can use a stored procedure to handle insertions into the view.
-- Alternatively, we can create a trigger on the base tables.

-- In MySQL, we create a stored procedure to insert into the view
DROP PROCEDURE IF EXISTS InsertIntoLondonHotelRoom;
DELIMITER //
CREATE PROCEDURE InsertIntoLondonHotelRoom(
    IN p_hotelNo INT,
    IN p_hotelName VARCHAR(50),
    IN p_roomNo INT,
    IN p_type VARCHAR(20),
    IN p_price DECIMAL(10, 2)
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
    INSERT INTO Room (roomNo, hotelNo, type, price) 
    VALUES (p_roomNo, p_hotelNo, p_type, p_price);
END //
DELIMITER ;

-- Example usage:
-- CALL InsertIntoLondonHotelRoom(5, 'New London Hotel', 1, 'double', 200.00);
