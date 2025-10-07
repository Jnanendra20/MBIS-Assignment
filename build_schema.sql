/*
This was used to create the Schema for the MBIS project (unextended), before being loaded into the EER diagram editor in MySQL Workbench.


*/

-- This was used over and over while getting it right, so we have these here for convenience's sake
USE wes_database;
DROP TABLE IF EXISTS HireItem;
DROP TABLE IF EXISTS HireAgreement;
DROP TABLE IF EXISTS MaintenanceLog;
DROP TABLE IF EXISTS ServiceProvider;
DROP TABLE IF EXISTS EquipmentItem;
DROP TABLE IF EXISTS EquipmentType;
DROP TABLE IF EXISTS TripRegistration;
DROP TABLE IF EXISTS ScheduledTrip;
DROP TABLE IF EXISTS TripType;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Customer;


CREATE TABLE Customer (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  dob DATE,
  customer_type ENUM('Student', 'Staff', 'Alumni', 'Guest') NOT NULL,
  sponsor_id INT
    );

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT UNIQUE,
    staff_name VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
    );

CREATE TABLE TripType (
  trip_code VARCHAR(10) PRIMARY KEY NOT NULL,
  trip_name VARCHAR(100) NOT NULL,
  difficulty_level ENUM('Easy','Moderate','Hard','Expert'),
  fee DECIMAL(8,2) NOT NULL,
  length_days INT NOT NULL
);

CREATE TABLE ScheduledTrip (
  scheduled_trip_id INT PRIMARY KEY AUTO_INCREMENT,
  trip_code VARCHAR(10) NOT NULL,
  trip_date DATE NOT NULL,
  leader_id INT NOT NULL,
  assistant_id INT NOT NULL
);

CREATE TABLE TripRegistration (
  scheduled_trip_id INT NOT NULL,
  customer_id INT NOT NULL,
  signed_waiver BOOL NOT NULL,
  PRIMARY KEY (scheduled_trip_id, customer_id)
);

CREATE TABLE EquipmentType (
  equipment_type_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  daily_rate_student DECIMAL(6,2) NOT NULL,
  daily_rate_staff_alumni DECIMAL(6,2) NOT NULL,
  daily_rate_guest DECIMAL(6,2) NOT NULL
);

CREATE TABLE EquipmentItem (
  equipment_id INT PRIMARY KEY AUTO_INCREMENT,
  equipment_type_id INT NOT NULL,
  `condition` ENUM('Good','Fair','Poor') NOT NULL
);

CREATE TABLE ServiceProvider (
    service_provider_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_name VARCHAR(150) NOT NULL,
    contact_phone VARCHAR(20),
    specialty VARCHAR(100)
);

CREATE TABLE MaintenanceLog (
	maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
    equipment_id INT NOT NULL,
    staff_id INT NOT NULL,
    service_provider_id INT,
    maintenance_date DATE NOT NULL,
    description TEXT NOT NULL,
    cost DECIMAL(8,2),
    FOREIGN KEY (equipment_id) REFERENCES EquipmentItem (equipment_id),
    FOREIGN KEY (staff_id) REFERENCES Staff (staff_id),
    FOREIGN KEY (service_provider_id) REFERENCES ServiceProvider (service_provider_id)
);

CREATE TABLE HireAgreement (
  hire_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  staff_id INT NOT NULL,
  hire_date DATE NOT NULL
);

CREATE TABLE HireItem (
  hire_id INT NOT NULL,
  equipment_id INT NOT NULL,
  expected_return DATE NOT NULL,
  actual_return DATE,
  PRIMARY KEY (hire_id, equipment_id)
);

-- Enfore trip uniqueness
CREATE UNIQUE INDEX ScheduledTrip_Unique_Date_Type 
  ON ScheduledTrip (trip_code, trip_date);

ALTER TABLE Customer 
  ADD FOREIGN KEY (sponsor_id) REFERENCES Customer (customer_id)
  ON DELETE SET NULL;

ALTER TABLE ScheduledTrip 
  ADD FOREIGN KEY (trip_code) REFERENCES TripType (trip_code);

ALTER TABLE ScheduledTrip 
  ADD FOREIGN KEY (leader_id) REFERENCES Staff (staff_id);

ALTER TABLE ScheduledTrip 
  ADD FOREIGN KEY (assistant_id) REFERENCES Staff (staff_id);

ALTER TABLE TripRegistration
  ADD FOREIGN KEY (scheduled_trip_id) REFERENCES ScheduledTrip (scheduled_trip_id);

ALTER TABLE TripRegistration 
  ADD FOREIGN KEY (customer_id) REFERENCES Customer (customer_id);

ALTER TABLE EquipmentItem 
  ADD FOREIGN KEY (equipment_type_id) REFERENCES EquipmentType (equipment_type_id);

ALTER TABLE HireAgreement 
  ADD FOREIGN KEY (customer_id) REFERENCES Customer (customer_id);

ALTER TABLE HireAgreement 
  ADD FOREIGN KEY (staff_id) REFERENCES Staff (staff_id);

ALTER TABLE HireItem 
  ADD FOREIGN KEY (hire_id) REFERENCES HireAgreement (hire_id); 

ALTER TABLE HireItem 
  ADD FOREIGN KEY (equipment_id) REFERENCES EquipmentItem (equipment_id);