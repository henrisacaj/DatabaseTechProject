/********************************************************
* This script creates the database named gym-gym
*********************************************************/

DROP DATABASE IF EXISTS gym;
CREATE DATABASE gym;
USE gym;

-- create the table for the database

CREATE TABLE membership (
	membership_id	INT	PRIMARY KEY	AUTO_INCREMENT,
	membership_type VARCHAR(30) UNIQUE NOT NULL,
    price DECIMAL(5, 2)
);

CREATE TABLE employee (
	employee_id	INT	PRIMARY KEY	AUTO_INCREMENT,
	first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    street VARCHAR(30),
	postal_code INT DEFAULT NULL,
	email VARCHAR(50) DEFAULT NULL UNIQUE,
    phone VARCHAR(20) DEFAULT NULL UNIQUE,
    iban VARCHAR(34) NOT NULL UNIQUE,
    position SET('Trainer', 'Instructor', 'Accountant', 'Housekeeping', 'Janitor', 'CEO'),
    birthday DATE DEFAULT NULL,
    CONSTRAINT `CHECK_EMPLOYEE_EMAIL` CHECK(REGEXP_LIKE(email, '^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,4}$')),
    CONSTRAINT `CHECK_EMPLOYEE_IBAN` CHECK(REGEXP_LIKE(iban, '^DE[a-zA-Z0-9]{2}\s?([0-9]{4}\s?){4}([0-9]{2})\s?$'))
);


CREATE TABLE trainer (
	trainer_id INT PRIMARY KEY,
    qualifications ENUM('A-Lizenz', 'B-Lizenz') NOT NULL,
    CONSTRAINT FOREIGN KEY (trainer_id)
        REFERENCES employee (employee_id) ON DELETE CASCADE 
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    membership_id INT NOT NULL,
    first_name VARCHAR(30) NOT NULL, #REGEX
    last_name VARCHAR(30) NOT NULL, #REGEX
    street VARCHAR(30) NOT NULL,
    postal_code INT DEFAULT NULL,
    email VARCHAR(50) DEFAULT NULL UNIQUE,
    phone VARCHAR(20) DEFAULT NULL UNIQUE,
    iban VARCHAR(34) NOT NULL UNIQUE,
    joining_date DATE NOT NULL,
    hours DECIMAL(10, 1) DEFAULT 0,
    last_login TIMESTAMP,
    birthday DATE DEFAULT NULL,
    CONSTRAINT FOREIGN KEY (membership_id)
        REFERENCES membership (membership_id) ON DELETE CASCADE,
	CONSTRAINT `CHECK_POSTAL_CODE` CHECK(REGEXP_LIKE(postal_code, '^[0-9]{5}$')),
    CONSTRAINT `CHECK_CUSTOMER_EMAIL` CHECK(REGEXP_LIKE(email, '^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,4}$')),
    CONSTRAINT `CHECK_CUSTOMER_IBAN` CHECK(REGEXP_LIKE(iban, '^DE[a-zA-Z0-9]{2}\s?([0-9]{4}\s?){4}([0-9]{2})\s?$'))
);

CREATE TABLE trains (
	trainer_id INT, 
    customer_id INT PRIMARY KEY, 
    CONSTRAINT FOREIGN KEY (trainer_id)
        REFERENCES trainer (trainer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE room (
	room_id	INT	PRIMARY KEY	AUTO_INCREMENT,
	size INT CHECK(size > 0),
    room_name VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE course (
	course_id	INT	PRIMARY KEY	AUTO_INCREMENT,
    room_id INT,
	course_name ENUM('Functional', 'Endurance', 'Stretch') NOT NULL,
    course_description VARCHAR(100) DEFAULT NULL, # Full text index
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE equipment (
	equipment_id	INT	PRIMARY KEY	AUTO_INCREMENT,
    room_id INT,
	equipment_name VARCHAR (30) NOT NULL,
    last_maintainance DATE,
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE extra (
	extra_id	INT	PRIMARY KEY	AUTO_INCREMENT,
    room_id INT NOT NULL,
	extra_name VARCHAR (30) NOT NULL,
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE
);

CREATE TABLE includes(
	membership_id INT NOT NULL,
    extra_id INT NOT NULL,
    PRIMARY KEY (membership_id, extra_id),
    CONSTRAINT FOREIGN KEY (membership_id) REFERENCES membership (membership_id) ON DELETE CASCADE,
    CONSTRAINT FOREIGN KEY (extra_id) REFERENCES extra (extra_id) ON DELETE CASCADE
);

CREATE TABLE attends (
	customer_id	INT	NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (customer_id, course_id),
    CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
);

CREATE TABLE teaches (
	trainer_id	INT	NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (trainer_id, course_id),
    CONSTRAINT FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id) ON DELETE CASCADE,
    CONSTRAINT FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
);

# Indexes
# SELECT Statements
# Views