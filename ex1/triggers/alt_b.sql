-- ==========================================
-- LAB 5: TRIGGERS - Task b (Derived Attribute)
-- Database: COMPANY_Lab5
-- ==========================================
-- b. Alter table Department to add the attribute Num_of_Emp that stores 
--    the number of employees working for each department. This attribute 
--    is a derived attribute from Employee.Dno and its value must be 
--    automatically calculated.
-- ==========================================

USE COMPANY_Lab5;

-- -----------------------------------------
-- Step 1: Add Num_of_Emp column to DEPARTMENT table
-- -----------------------------------------

ALTER TABLE DEPARTMENT 
ADD COLUMN Num_of_Emp INT DEFAULT 0;

-- -----------------------------------------
-- Step 2: Initialize Num_of_Emp with current employee counts
-- -----------------------------------------

UPDATE DEPARTMENT d
SET Num_of_Emp = (
    SELECT COUNT(*) 
    FROM EMPLOYEE e 
    WHERE e.Dno = d.Dnumber
);

-- -----------------------------------------
-- Step 3: Trigger for INSERT - Increment Num_of_Emp when new employee is added
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_update_num_emp_insert;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_insert
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Dno IS NOT NULL THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = Num_of_Emp + 1
        WHERE Dnumber = NEW.Dno;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Step 4: Trigger for DELETE - Decrement Num_of_Emp when employee is removed
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_update_num_emp_delete;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_delete
AFTER DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF OLD.Dno IS NOT NULL THEN
        UPDATE DEPARTMENT 
        SET Num_of_Emp = Num_of_Emp - 1
        WHERE Dnumber = OLD.Dno;
    END IF;
END //
DELIMITER ;

-- -----------------------------------------
-- Step 5: Trigger for UPDATE - Update Num_of_Emp when employee changes department
-- -----------------------------------------

DROP TRIGGER IF EXISTS trg_update_num_emp_update;
DELIMITER //
CREATE TRIGGER trg_update_num_emp_update
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    -- Check if department changed
    IF OLD.Dno != NEW.Dno OR (OLD.Dno IS NULL AND NEW.Dno IS NOT NULL) OR (OLD.Dno IS NOT NULL AND NEW.Dno IS NULL) THEN
        -- Decrement old department
        IF OLD.Dno IS NOT NULL THEN
            UPDATE DEPARTMENT 
            SET Num_of_Emp = Num_of_Emp - 1
            WHERE Dnumber = OLD.Dno;
        END IF;
        
        -- Increment new department
        IF NEW.Dno IS NOT NULL THEN
            UPDATE DEPARTMENT 
            SET Num_of_Emp = Num_of_Emp + 1
            WHERE Dnumber = NEW.Dno;
        END IF;
    END IF;
END //
DELIMITER ;
