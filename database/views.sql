#### Hilfreiche Views für Customer und Trainer ####

# View für die Trainer, die zeigt, welchen Kunden sie als Personal Trainer zugewiesen sind
CREATE OR REPLACE VIEW personal_trainer_customer
AS 
SELECT trainer.trainer_id, c.first_name, c.last_name
FROM  trainer JOIN trains ON trainer.trainer_id = trains.trainer_id
	JOIN customer c on trains.customer_id = c.customer_id
WITH CHECK OPTION;

# View für die Trainer, die zeigt, welche Kurse sie gerade leiten und welche Kunden diese Kurse besuchen
CREATE OR REPLACE VIEW trainer_course
AS 
SELECT trainer.trainer_id, course_name, cu.first_name as customer_first_name, cu.last_name as customer_last_name, room_name
FROM  trainer JOIN teaches ON trainer.trainer_id = teaches.trainer_id
	JOIN course co ON  co.course_id = teaches.course_id
    JOIN attends a  ON a.course_id = co.course_id
	JOIN customer cu ON a.customer_id = cu.customer_id
    JOIN room r ON r.room_id = co.room_id
ORDER BY trainer_id
WITH CHECK OPTION;

# View für die Customer, die zeigt, welche Extras man mit welchem Membership erhält und wo diese stattfinden
CREATE OR REPLACE VIEW membership_extra
AS 
SELECT membership_type, extra_name, room_name
FROM membership m JOIN includes i ON m.membership_id = i.membership_id
	JOIN extra e ON e.extra_id = i.extra_id
    JOIN room r ON r.room_id = e.room_id
ORDER BY FIELD(membership_type, 'bronze', 'silver', 'gold', 'platin', 'diamant')
WITH CHECK OPTION;
