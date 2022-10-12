# Anzahl an Kunden, die ein bestimmtes Abo haben + monatlicher Umsatz(gruppiert nach type) 

SELECT membership_type, COUNT(customer_id) as customer_count, COUNT(customer_id) * price as monthly_income
FROM customer c JOIN membership m ON c.membership_id = m.membership_id
GROUP BY membership_type;

# Geräte, die seit einem Jahr nicht gewartet wurden 

SELECT equipment_name 
FROM equipment e
WHERE checkOlderThan(last_maintainance, 365 * 2);

# Welche Extras kriegt man für welche Memberships?

SELECT membership_type, extra_name
FROM membership m JOIN includes i ON m.membership_id = i.membership_id
	JOIN extra e ON e.extra_id = i.extra_id
ORDER BY FIELD(membership_type, 'bronze', 'silver', 'gold', 'platin', 'diamant');

# Wieviele Stunden verbringen Member im Durchschnitt, die seit mindestens einem Jahr dabei sind? (gruppiert nach Membership)

SELECT membership_type, ROUND(AVG(hours), 2) as average_hours
FROM customer c JOIN membership m ON c.membership_id = m.membership_id
WHERE checkOlderThan(c.joining_date, 365)
GROUP BY membership_type
ORDER BY average_hours DESC;

# Customers, die heute Geburtstag haben

SELECT last_name, first_name
FROM customer c
WHERE getMonthDay(c.birthday) = getMonthDay(CURDATE()) ;

# Welche Employees, die A-Lizenz haben, leiten mindestens 2 Kurse?

SELECT first_name, last_name, COUNT(*) as courses_teached
FROM (SELECT *
	  FROM trainer 
      WHERE qualifications = 'A-Lizenz'
    ) t JOIN employee e ON t.trainer_id = e.employee_id
		JOIN teaches ON teaches.trainer_id = t.trainer_id
GROUP BY t.trainer_id
HAVING courses_teached >= 2;

# Trainer, die keine Personal Customer haben oder keine Kurse zurzeit leiten

SELECT DISTINCT trainer.trainer_id, first_name, last_name
FROM trainer JOIN employee e ON e.employee_id = trainer.trainer_id 
	LEFT JOIN trains ON trainer.trainer_id = trains.trainer_id
    LEFT JOIN teaches ON trainer.trainer_id = teaches.trainer_id
WHERE trains.trainer_id IS NULL OR teaches.trainer_id IS NULL;

# Kurse, die Chest in course_description enthalten
# Ohne FULL TEXT INDEX
SELECT course_description 
FROM course 
WHERE course_description LIKE "%functions%";

# Mit FULL TEXT INDEX
SELECT course_description
FROM course
WHERE MATCH (course_description) AGAINST ('.*functions.*');

