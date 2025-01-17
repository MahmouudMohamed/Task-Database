create database test
use test
CREATE TABLE Patient (
    UR_Number INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Address VARCHAR(50)not null,
    Age INT not null,
    Email VARCHAR(100),
    Phone VARCHAR(20)not null,
    MedCard_Num VARCHAR(20)not null,
    Doctor_ID INT,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);
CREATE TABLE Doctor (
    Doctor_ID INT PRIMARY KEY,
    Name VARCHAR(50) not null,
    Email VARCHAR(50) not null,
    Phone VARCHAR(20) not null,
    Specialty VARCHAR(50) not null,
    Years_of_Exp INT not null
);
CREATE TABLE Drug (
    Trade_Name VARCHAR(100) PRIMARY KEY,
    Strength VARCHAR(50),
    Company_Name VARCHAR(150),
    FOREIGN KEY (Company_Name) REFERENCES Pharm_Company(Company_Name)
);
CREATE TABLE Pharm_Company (
    Company_Name VARCHAR(150) PRIMARY KEY,
    Address VARCHAR(100),
    Phone VARCHAR(20)
);
CREATE TABLE Prescription (
    Prescription_ID INT PRIMARY KEY,
    Date DATE NOT NULL,
    Quantity INT NOT NULL,
    Patient_UR_Number INT,
    Doctor_ID INT,
    Trade_Name VARCHAR(100),
    FOREIGN KEY (Patient_UR_Number) REFERENCES Patient(UR_Number),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID),
    FOREIGN KEY (Trade_Name) REFERENCES Drug(Trade_Name)
);


	-- 1. SELECT: Retrieve all columns from the Doctor table.
		SELECT * FROM Doctor

	-- 2. ORDER BY: List patients in the Patient table in ascending order of their ages.
		SELECT * FROM Patient
		ORDER BY Age ASC

	-- 3. OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
		SELECT * FROM Patient
		ORDER BY UR_Number
		OFFSET 4 ROWS FETCH NEXT 10 ROWS ONLY

	-- 4. SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
		SELECT TOP 5 * FROM Doctor

	-- 5. SELECT DISTINCT: Get a list of unique addresses from the Patient table.
		SELECT DISTINCT Address FROM Patient

	-- 6. WHERE: Retrieve patients from the Patient table who are aged 25.
		SELECT * FROM Patient
		WHERE Age = 25

	-- 7. NULL: Retrieve patients from the Patient table whose email is not provided.
		SELECT * FROM Patient
		WHERE Email IS NULL

	-- 8. AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'Cardiology'.
		SELECT * FROM Doctor
		WHERE Years_of_Exp > 5 AND Specialty = 'Cardiology'

	-- 9. IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'.
		SELECT * FROM Doctor
		WHERE Specialty IN ('Dermatology', 'Oncology')

	-- 10. BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
		SELECT * FROM Patient
		WHERE Age BETWEEN 18 AND 30

	-- 11. LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.
		SELECT * FROM Doctor
		WHERE Name LIKE 'Dr.%';

	-- 12. Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
		SELECT Name AS DoctorName, Email AS DoctorEmail FROM Doctor;

	-- 13. Joins: Retrieve all prescriptions with corresponding patient names.
		SELECT P.Name AS PatientName, P.* 
		FROM Prescription R
		JOIN Patient P ON R.Patient_UR_Number = p.UR_Number;

	-- 14. GROUP BY: Retrieve the count of patients grouped by their cities.
		SELECT Address, COUNT(*) AS PCount
		FROM Patient
		GROUP BY Address;

	-- 15. HAVING: Retrieve cities with more than 3 patients.
		SELECT Address, COUNT(*) AS PCount
		FROM Patient
		GROUP BY Address
		HAVING COUNT(*) > 3;

	-- 16. GROUPING SETS: Retrieve counts of patients grouped by cities and ages.
		SELECT Address, Age, COUNT(*) AS PCount
		FROM Patient
		GROUP BY GROUPING SETS ((Address), (Age));

	-- 17. CUBE: Retrieve counts of patients considering all possible combinations of city and age.
		SELECT Address, Age, COUNT(*) AS PCount
		FROM Patient
		GROUP BY CUBE (Address, Age);

	-- 18. ROLLUP: Retrieve counts of patients rolled up by city.
		SELECT Address, COUNT(*) AS PCount
		FROM Patient
		GROUP BY ROLLUP (Address);

	-- 19. EXISTS: Retrieve patients who have at least one prescription.
		SELECT * FROM Patient P
		WHERE EXISTS (
		SELECT 1 FROM Prescription R WHERE R.Patient_UR_Number = P.UR_Number
		);

	-- 20. UNION: Retrieve a combined list of doctors and patients.
		SELECT Name FROM Doctor
		UNION
		SELECT Name FROM Patient;

	-- 20. UNION: Retrieve a combined list of doctors and patients.
		SELECT Name FROM Doctor
		UNION
		SELECT Name FROM Patient;

	-- 21. Common Table Expression (CTE): Retrieve patients along with their doctors using a CTE.
		WITH PatientDoctor AS (
			SELECT P.Name AS PName, D.Name AS DName
			FROM Patient P
			JOIN Doctor D ON P.Doctor_ID = D.Doctor_ID
		)
		SELECT * FROM PatientDoctor;

	-- 22. INSERT: Insert a new doctor into the Doctor table.
		INSERT INTO Doctor (Name, Specialty, Years_of_Exp, Email)
		VALUES ('Dr.Mahmoud Ouf', 'physics', 3, 'mahmoudouf504@gmail.com')

	-- 23. INSERT Multiple Rows: Insert multiple patients into the Patient table.
		INSERT INTO Patient (Name, Age, Address, Email)
		VALUES ('Mahmoud', 25, 'Awsim', 'mahmoudouf500@gmail.com'),
			   ('Ouf', 26, 'Giza', 'mahmoud25@gmail.com')

	-- 24. UPDATE: Update the phone number of a doctor.
		UPDATE Doctor
		SET Phone = '01091326262'
		WHERE Doctor_ID = 2

	-- 25. UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.
		UPDATE P
		SET P.Address = 'New City'
		FROM Patient P
		JOIN Prescription R ON P.UR_Number = R.Patient_UR_Number
		JOIN Doctor D ON R.Doctor_ID = D.Doctor_ID
		WHERE D.Name = 'Dr.Mahmoud Ouf';

	-- 26. DELETE: Delete a patient from the Patient table.
		DELETE FROM Patient
		WHERE UR_Number = 1;

	-- 27. Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO Doctor (Name, Specialty, Years_of_Exp, Email) 
			VALUES ('Dr.Mahmoud', 'aaa', 20, 'mahmoud@gmail.com');
			INSERT INTO Patient (Name, Age, Address, Email)
			VALUES ('mohamed', 25, 'Giza', 'mohamed@gmail.com');
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
		END CATCH;

	-- 28. View: Create a view that combines patient and doctor information for easy access.
		CREATE VIEW PDView AS
		SELECT P.Name AS PName, D.Name AS DName, P.Age, P.Address
		FROM Patient P
		JOIN Doctor D ON P.Doctor_ID = D.Doctor_ID;

	-- 29. Index: Create an index on the 'phone' column of the Patient table to improve search performance.
		CREATE INDEX IDX_Phone ON Patient(Phone);

	-- 30. Backup: Perform a backup of the entire database to ensure data safety.
	-- Example command for SQL Server:
		BACKUP DATABASE MyDatabase
		TO DISK = 'D:\Backup\SQLSAVE.bak';

