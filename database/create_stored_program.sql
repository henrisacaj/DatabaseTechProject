/********************************************************
* This script creates the database stored programs
  __ _ _   _ _ __ ___  
 / _` | | | | '_ ` _ \ 
| (_| | |_| | | | | | |
 \__, |\__, |_| |_| |_|
  __/ | __/ |          
 |___/ |___/       
*********************************************************/

-- -------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `create_new_customer`
(
	IN p_membership_id INT, 
    IN p_first_name VARCHAR(30), 
    IN p_last_name VARCHAR(30), 
    IN p_street VARCHAR(30), 
    IN p_postal_code INT, 
    IN p_email VARCHAR(50), 
    IN p_phone VARCHAR(20), 
    IN p_iban VARCHAR(34), 
    IN p_birthday DATE
)
    MODIFIES SQL DATA
BEGIN

	DECLARE errno INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION -- SQLEXCEPTION: Shorthand for the class of SQLSTATE values that do not begin with '00', '01', or '02'. 
		BEGIN 
			GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO;
            SELECT errno AS MYSQL_ERROR;
            ROLLBACK;
        END;
        
	START TRANSACTION;
	
		INSERT INTO customer (membership_id, first_name, last_name, street, postal_code, email, phone, iban, joining_date, birthday) 
		VALUES(p_membership_id, p_first_name, p_last_name, p_street, p_postal_code, p_email, p_phone, p_iban, DATE(NOW()), p_birthday);
	
    COMMIT;

END$$
DELIMITER ;


-- -------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `delete_customer`
(
	IN p_customer_id INT
)
    MODIFIES SQL DATA
BEGIN

	DECLARE errno INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION -- SQLEXCEPTION: Shorthand for the class of SQLSTATE values that do not begin with '00', '01', or '02'. 
		BEGIN 
			GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO;
            SELECT errno AS MYSQL_ERROR;
            ROLLBACK;
        END;
    
	START TRANSACTION;
	
		DELETE FROM customer WHERE customer_id = p_customer_id;
	
    COMMIT;

END$$
DELIMITER ;

-- -------------------------------------------------------------------------------------------------------------
-- Check customer name with customerid OR show the customer_id for given customer with firstname and lastname
DELIMITER $$
CREATE FUNCTION `check_user_with_id`(p_customer_id INT) RETURNS VARCHAR(60)
READS SQL DATA

BEGIN
	
    DECLARE customer_name VARCHAR(60);
    
	SELECT CONCAT(first_name, " ", last_name) AS name INTO customer_name
    FROM customer
    WHERE customer_id = p_customer_id;
	RETURN customer_name;

END$$
DELIMITER ;

-- -------------------------------------------------------------------------------------------------------------
-- show the customer_id for given customer with firstname and lastname and birthday
DELIMITER $$
CREATE FUNCTION `check_user_with_name`(p_first_name VARCHAR(30), p_last_name VARCHAR(30), p_birthday DATE) RETURNS INT
READS SQL DATA

BEGIN
	
    DECLARE id INT;
    
	SELECT customer_id INTO id
    FROM customer
    WHERE first_name = p_first_name AND last_name = p_last_name AND birthday = p_birthday;
	RETURN id;

END$$
DELIMITER ;


-- -----------------------------------------------------------------------------------------------------------

CALL create_new_customer(5, 'PETER', 'pan', 'Am Berg 3', '22123', 'peter@pan.de', '016459495', 'DE40090572231221179169', '1977-10-11');

SELECT check_user_with_name('Peter', 'Pan', '1977-10-11');

SELECT check_user_with_id (105);

CALL delete_customer(105);


-- -------------------------------------------------------------------------------------------------------------
-- function to extract month and day
DELIMITER $$

CREATE FUNCTION getMonthDay (p_date DATE) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN 
    RETURN date_format(p_date, '%m-%d');
END $$

DELIMITER ;



-- -------------------------------------------------------------------------------------------------------------
-- event for customer birthday
DELIMITER $$
CREATE EVENT event_customer_birthday
ON SCHEDULE EVERY 1 DAY
STARTS '2022-11-11'
DO BEGIN
	SELECT customer_id AS ID, CONCAT(first_name, ' ', last_name) AS 'Customer name', birthday AS 'Birthday', (YEAR(DATE(NOW())) - YEAR(birthday)) AS age
	FROM customer
	WHERE getMonthDay(NOW()) = getMonthDay(birthday);

END$$
DELIMITER ;

SHOW EVENTS;


-- -------------------------------------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION checkOlderThan (p_date DATE, p_interval INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN 
    DECLARE result INT DEFAULT 0;
    IF datediff(CURDATE(), p_date) > p_interval 
    THEN SET result = 1;
    END IF;
    RETURN result;
END $$

DELIMITER ;

DROP FUNCTION checkOlderThan;


-- -------------------------------------------------------------------------------------------------------------
-- Trigger: Name in correct format
DELIMITER $$

CREATE TRIGGER format_new_customer_name BEFORE INSERT ON customer
FOR EACH ROW
Begin
	SET NEW.first_name = CONCAT(UPPER(SUBSTRING(NEW.first_name FROM 1 FOR 1)),LOWER(SUBSTRING(NEW.first_name, 2, LENGTH(new.first_name) )));
    SET NEW.last_name = CONCAT(UPPER(SUBSTRING(NEW.last_name, 1, 1)), LOWER(SUBSTRING(NEW.last_name, 2, LENGTH(NEW.last_name))));

END$$

DELIMITER ;



-- -------------------------------------------------------------------------------------------------------------






