/********************************************************
* This script creates the database named gym-gym
*********************************************************/

DROP DATABASE IF EXISTS gym;
CREATE DATABASE gym;
USE gym;

-- create the table for the database

CREATE TABLE membership (
	membership_id	INT	PRIMARY KEY	AUTO_INCREMENT,
	type VARCHAR(30) UNIQUE NOT NULL,
    price INT DEFAULT NULL
);

CREATE TABLE trainer (
	trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    qualifications VARCHAR(50) NOT NULL
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    membership_id INT NOT NULL,
    trainer_id INT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    street VARCHAR(30),
    postal_code INT DEFAULT NULL,
    email VARCHAR(50) DEFAULT NULL UNIQUE,
    phone VARCHAR(20) DEFAULT NULL UNIQUE,
    iban VARCHAR(34) NOT NULL UNIQUE,
    joining_date DATE,
    hours INT DEFAULT 0,
    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    birthday DATE DEFAULT NULL,
    CONSTRAINT FOREIGN KEY (membership_id)
        REFERENCES membership (membership_id),
    CONSTRAINT FOREIGN KEY (trainer_id)
        REFERENCES trainer (trainer_id)
);

CREATE TABLE employee (
	employee_id	INT	PRIMARY KEY	AUTO_INCREMENT,
	first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    position VARCHAR(30) DEFAULT NULL,
    street VARCHAR(30),
    postal_code INT DEFAULT NULL,
    email VARCHAR(50) DEFAULT NULL UNIQUE,
    phone VARCHAR(20) DEFAULT NULL UNIQUE,
    iban VARCHAR(34) NOT NULL UNIQUE,
    birthday DATE DEFAULT NULL
);

CREATE TABLE room (
	room_id	INT	PRIMARY KEY	AUTO_INCREMENT,
	size INT,
    type VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE course (
	course_id	INT	PRIMARY KEY	AUTO_INCREMENT,
    room_id INT NOT NULL,
	type VARCHAR(30) UNIQUE NOT NULL,
    description VARCHAR(100) DEFAULT NULL,
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id)
);

CREATE TABLE equipment (
	equipment_id	INT	PRIMARY KEY	AUTO_INCREMENT,
    room_id INT NOT NULL,
	name VARCHAR (30) NOT NULL,
    last_maintainance DATE, 
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id)
);

CREATE TABLE extra (
	extra_id	INT	PRIMARY KEY	AUTO_INCREMENT,
    room_id INT NOT NULL,
	name VARCHAR (30) NOT NULL,
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id)
);

CREATE TABLE attends (
	member_id	INT	NOT NULL,
    room_id INT NOT NULL,
    PRIMARY KEY (member_id, room_id),
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id)
);

CREATE TABLE teaches (
	trainer_id	INT	NOT NULL,
    room_id INT NOT NULL,
    PRIMARY KEY (trainer_id, room_id),
    CONSTRAINT FOREIGN KEY (room_id) REFERENCES room(room_id)
);

