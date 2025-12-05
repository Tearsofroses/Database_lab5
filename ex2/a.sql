-- ==========================================
-- CONSTRAINT a: The price of all double rooms must be greater than $100.
-- ==========================================

USE Hotel_Lab5;

-- Using CHECK constraint
ALTER TABLE Room 
ADD CONSTRAINT chk_double_room_price 
CHECK (type != 'double' OR price > 100);
