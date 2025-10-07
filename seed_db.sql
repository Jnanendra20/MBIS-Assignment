USE wes_database;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM HireItem;
DELETE FROM HireAgreement;
DELETE FROM MaintenanceLog;
DELETE FROM ServiceProvider;
DELETE FROM EquipmentItem;
DELETE FROM EquipmentType;
DELETE FROM TripRegistration;
DELETE FROM ScheduledTrip;
DELETE FROM TripType;
DELETE FROM Staff;
DELETE FROM Customer;
ALTER TABLE Customer AUTO_INCREMENT = 1;
ALTER TABLE Staff AUTO_INCREMENT = 1;
ALTER TABLE ScheduledTrip AUTO_INCREMENT = 1;
ALTER TABLE EquipmentType AUTO_INCREMENT = 1;
ALTER TABLE EquipmentItem AUTO_INCREMENT = 1;
ALTER TABLE ServiceProvider AUTO_INCREMENT = 1;
ALTER TABLE MaintenanceLog AUTO_INCREMENT = 1;
ALTER TABLE HireAgreement AUTO_INCREMENT = 1;
SET SQL_SAFE_UPDATES = 1;
INSERT INTO Customer (customer_id, name, phone, dob, customer_type, sponsor_id) VALUES
(1, 'Professor Professorson', '0211234567', '1990-04-15', 'Staff', NULL), -- id 1.
(2, 'Underpaid Tutor', '0227654321', '1985-09-20', 'Staff', NULL), -- id 2.
(3, 'David Goggins', '0208888888', '2000-02-12', 'Guest', 1), -- Guest, sponsored by Prof and id 3.
(4, 'Noam Chomsky', '0273333333', '1995-07-05', 'Alumni', NULL), -- id 4.
(5, 'Bob Bobbington', '0215555555', '1988-12-22', 'Guest', 2); -- Guest, sponsored by Tutor and id 5. 

INSERT INTO Staff (staff_id, customer_id, staff_name, position) VALUES
(1, 1, 'Professor Professorson', 'Trip Coordinator'),
(2, 2, 'Underpaid Tutor', 'Equipment Manager'),
(3, 4, 'Noam Chomsky', 'Senior Guide');

INSERT INTO TripType (trip_code, trip_name, difficulty_level, fee, length_days) VALUES
('4123', 'Beginners Kayaking', 'Easy', 120.00, 2),
('5123', 'Advanced Kayaking', 'Hard', 450.00, 4),
('4123B', 'Begginers Kayaking (Long Course)', 'Moderate', 300.00, 6);

INSERT INTO ScheduledTrip (scheduled_trip_id, trip_code, trip_date, leader_id, assistant_id) VALUES
(1, '4123', '2025-11-01', 1, 2), -- Led by Prof (staff_id 1), assisted by Tutor (staff_id 2)
(2, '5123', '2025-12-01', 1, 3), -- Led by Prof (staff_id 1), assisted by Noam (staff_id 3)
(3, '4123B', '2025-11-01', 1, 2),
(4, '4123', '2026-01-21', 3, 1);

INSERT INTO TripRegistration (scheduled_trip_id, customer_id, signed_waiver) VALUES
(1, 1, TRUE),	-- PP going on trip 1
(1, 3, TRUE),	-- DG going on trip 1
(2, 2, TRUE), 	-- UT going on trip 2
(2, 5, FALSE),  -- BB going on trip 2
(3, 4, TRUE);	-- NC going on trip 3

INSERT INTO EquipmentType (name, daily_rate_student, daily_rate_staff_alumni, daily_rate_guest) VALUES
('Kayak', 10.00, 12.00, 15.00), 			-- id 1
('Sleeping Bag', 5.00, 6.00, 8.00),			-- id 2
('Backpack', 7.00, 8.00, 10.00),			-- id 3
('Climbing Rope', 12.00, 14.00, 18.00);		-- id 4

INSERT INTO EquipmentItem (equipment_type_id, `condition`) VALUES
(1, 'Good'), 	-- Kayak, id 1
(1, 'Fair'),	-- Kayak, id 2
(2, 'Good'),	-- Sleeping bag, id 3
(3, 'Poor'),	-- backpack, id 4
(4, 'Good'),	-- rope, id 5
(4, 'Fair');    -- rope, id 6

INSERT INTO ServiceProvider (provider_name, contact_phone, specialty) VALUES
('Pro-Gear Repairs Ltd', '03-355-1234', 'Fabric & Tent Repair'),
('Plastic Fantastic Kayaks', '03-366-5678', 'Kayak Hull & Rudder Service'),
('Southern Ropes Inc', '09-444-1111', 'Rope Safety Certification');

INSERT INTO MaintenanceLog (equipment_id, staff_id, service_provider_id, maintenance_date, description, cost) VALUES
(4, 2, NULL, '2025-09-15', 'Re-stitched shoulder strap on backpack. Condition upgraded to Fair.', 0.00), -- An internal repair handled by staff
(2, 2, 2, '2025-09-20', 'Patched 10cm crack in hull. Item is now watertight.', 150.00), -- An external repair for a kayak, handled by a service provider
(6, 2, 3, '2025-09-22', 'Annual safety and stress test passed. Certified for 1 more year.', 75.50), -- An external safety check for a rope
(3, 1, NULL, '2025-10-01', 'Washed and dried sleeping bag after hire.', 5.00), -- Another internal job
(4, 2, 1, '2025-10-05', 'Repaired tear in tent fly and re-sealed seams.', 95.00); -- A tent repair sent to an external provider

INSERT INTO HireAgreement (hire_id, customer_id, staff_id, hire_date) VALUES
(1, 1, 2, '2025-10-29'), -- hire overseen by Tutor (staff_id 2)
(2, 3, 3, '2025-10-02'), -- hire overseen by Noam (staff_id 3)
(3, 4, 2, '2025-10-03'); -- hire overseen by Tutor (staff_id 2)

INSERT INTO HireItem (hire_id, equipment_id, expected_return, actual_return) VALUES
(1, 1, '2025-11-06', '2025-11-05'), 	-- PP hired KAYAK, returned early
(1, 4, '2025-11-06', NULL),				-- PP hired backpack, not returned
(2, 3, '2025-10-06', '2025-10-06'),		-- DG hired sleeping bag, returned
(3, 5, '2025-10-07', NULL);				-- NC hired rope, not returned