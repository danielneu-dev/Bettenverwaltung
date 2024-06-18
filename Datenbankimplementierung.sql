--
-- Create schema bettenverwaltung
--

DROP DATABASE IF EXISTS bettenverwaltung;
CREATE DATABASE bettenverwaltung;
USE bettenverwaltung;

--
-- Definition of all tables
--

CREATE TABLE d_geschlecht(geschlecht VARCHAR(1) PRIMARY KEY);

CREATE TABLE d_status(status VARCHAR(12) PRIMARY KEY);

CREATE TABLE station(stationID INT PRIMARY KEY AUTO_INCREMENT,
		     bezeichnung VARCHAR(60) NOT NULL);

CREATE TABLE raum(raumID INT AUTO_INCREMENT,
                  stationID INT,
                  bezeichnung VARCHAR(60) NOT NULL,
                  FOREIGN KEY(stationID) REFERENCES station(stationID) ON DELETE CASCADE,
                  PRIMARY KEY(raumID, stationID));

CREATE TABLE person(personID INT PRIMARY KEY AUTO_INCREMENT,
                    vorname VARCHAR(60) NOT NULL,
                    nachname VARCHAR(60) NOT NULL,
                    geschlecht VARCHAR(1),
                    geburtsdatum DATE,
                    FOREIGN KEY(geschlecht) REFERENCES d_geschlecht(geschlecht));

CREATE TABLE bett(bettID INT PRIMARY KEY AUTO_INCREMENT,
                  status VARCHAR(12) DEFAULT 'frei',
                  FOREIGN KEY(status) REFERENCES d_status(status));

CREATE TABLE patient(personID INT,
                     bettID INT,
                     aufnahmedatum DATETIME NOT NULL,
                     entlassungsdatum DATETIME DEFAULT NULL,
                     FOREIGN KEY(personID) REFERENCES person(personID),
                     FOREIGN KEY(bettID) REFERENCES bett(bettID),
                     PRIMARY KEY(bettID, personID),
                     CONSTRAINT chk_datum CHECK (entlassungsdatum IS NULL OR entlassungsdatum >= aufnahmedatum));

CREATE TABLE reinigungskraft(personID INT,
                             FOREIGN KEY(personID) REFERENCES person(personID),
                             PRIMARY KEY(personID));

CREATE TABLE reinigung(personID INT,
                       bettID INT,
                       datum DATETIME NOT NULL,
                       FOREIGN KEY(personID) REFERENCES reinigungskraft(personID),
                       FOREIGN KEY(bettID) REFERENCES bett(bettID) ON DELETE CASCADE);

CREATE TABLE zuweisung(bettID INT,
                       raumID INT,
                       datum DATETIME NOT NULL,
                       FOREIGN KEY(bettID) REFERENCES bett(bettID) ON DELETE CASCADE,
                       FOREIGN KEY(raumID) REFERENCES raum(raumID) ON DELETE CASCADE);

--
-- Dumping data for all tables
--

INSERT INTO d_geschlecht (geschlecht)
VALUES  ('m'),
	('w');

INSERT INTO d_status (status)
VALUES  ('frei'),
	('belegt'),
	('kontaminiert');

INSERT INTO station (bezeichnung)
VALUES  ('Allgemeine Betreuung'),
	('Intensivpflege'),
	('Kardiologie'),
	('Neurologie'),
	('Chirurgie');

INSERT INTO raum (stationID, bezeichnung)
VALUES  (1,'Patientenzimmer 101'),(1,'Patientenzimmer 102'),(1,'Patientenzimmer 103'),(1,'Patientenzimmer 104'),(1,'Patientenzimmer 105'),
	(2,'Patientenzimmer 201'),(2,'Patientenzimmer 202'),(2,'Patientenzimmer 203'),(2,'Patientenzimmer 204'),(2,'Patientenzimmer 205'),
	(3,'Patientenzimmer 301'),(3,'Patientenzimmer 302'),(3,'Patientenzimmer 303'),(3,'Patientenzimmer 304'),(3,'Patientenzimmer 305'),
	(4,'Patientenzimmer 401'),(4,'Patientenzimmer 402'),(4,'Patientenzimmer 403'),(4,'Patientenzimmer 404'),(4,'Patientenzimmer 405'),
	(5,'Patientenzimmer 501'),(5,'Patientenzimmer 502'),(5,'Patientenzimmer 503'),(5,'Patientenzimmer 504'),(5,'Patientenzimmer 505');

INSERT INTO person (vorname, nachname, geschlecht, geburtsdatum)
VALUES  ('Anna','Müller','w','1988-05-15'),
	('David','Schmidt','m','1995-09-08'),
	('Lena','Wagner','w','1982-04-03'),
	('Tim','Becker','m','1990-07-21'),
	('Sarah','Fischer','w','1989-03-12'),
	('Jonas','Weber','m','1985-11-17'),
	('Laura','Schulz','w','1992-06-25'),
	('Nico','Bauer','m','1987-12-09'),
	('Julia','Keller','w','1998-02-06'),
	('Felix','Richter','m','1993-10-14'),
	('Max','Mustermann','m','1990-01-01');

INSERT INTO bett (status)
VALUES  ('belegt'),
	('frei'),
	('frei'),
	('kontaminiert'),
	('kontaminiert'),
	('belegt'),
	('belegt'),
	('belegt'),
	('belegt');

INSERT INTO bett (bettID, status)
VALUES (9558,'frei');

INSERT INTO patient (personID, bettID, aufnahmedatum)
VALUES  (2,1,'2023-06-14 15:45:08'),
	(7,6,'2022-12-29 07:18:49'),
	(3,7,'2023-04-17 21:06:13'),
	(8,9,'2023-12-01 06:59:01'),
	(5,8,'2023-11-27 00:57:38');

INSERT INTO patient (personID, bettID, aufnahmedatum, entlassungsdatum)
VALUES  (11,9558,'2018-10-15 20:15:32','2018-10-29 08:17:23');

INSERT INTO reinigungskraft (personID)
VALUES  (1),
	(4),
	(6),
	(9),
	(10);

INSERT INTO reinigung (personID, bettID, datum)
VALUES  (1,3,'2023-12-03 18:06:17'),
	(4,4,'2023-12-03 22:27:19'),
	(6,2,'2023-12-01 00:19:47'),
	(9,7,'2023-04-16 09:18:52'),
	(6,9558,'2018-10-14 09:56:39'),
	(10,9558,'2018-10-16 08:16:54'),
	(10,1,'2023-06-14 12:14:01');

INSERT INTO zuweisung (bettID, raumID, datum)
VALUES  (1,12,'2023-06-14 15:34:19'),
	(9558,25,'2018-10-14 08:13:29'),
	(6,25,'2022-12-29 07:13:02'),
	(7,20,'2023-04-16 00:14:46'),
	(8,3,'2023-11-24 16:16:31'),
	(9,18,'2023-11-30 19:34:07');
       
-- 
-- SQL-Statements
-- 

-- "Am 15.10.2018 wurde festgestellt, dass das Bett mit der ID:9558 kontaminiert ist. Welcher Patient belegte dieses Bett zuletzt?"
SELECT 
	p1.aufnahmedatum AS Aufnahmedatum,
	p1.entlassungsdatum AS Entlassungsdatum,
	bettID AS BettID,
	p1.personID AS PersonID,
	Vorname,
	Nachname
FROM
	patient p1
JOIN
	person p2 ON (p1.personID = p2.personID)
WHERE
	bettID=9558;

-- "Das Bett mit der ID:9558 wurde durch die Reinigung kontaminiert. In welchem Raum befand sich das Bett zuletzt und welche Patienten waren in diesem Zeitraum in diesem Raum."
SELECT
	z.bettID AS BettID,
	z.raumID AS RaumID, 
	r.bezeichnung AS Bezeichnung, 
	p1.personID AS PersonID, 
	p1.aufnahmedatum AS Aufnahmedatum, 
	p1.entlassungsdatum AS Entlassungsdatum, 
	Vorname, 
	Nachname
FROM 
	zuweisung z
JOIN 
	raum r ON (z.raumID = r.raumID)
JOIN
	patient p1 ON (z.bettID = p1.bettID)
JOIN 
	person p2 ON (p1.personID = p2.personID)
WHERE
	z.raumID = (SELECT
			raumID
		    FROM
			zuweisung
		    WHERE 
			bettID=9558);

-- "Wie viele Betten waren letztes Jahr an Weihnachten belegt?"
SELECT 
	COUNT(bettID) AS 'Anzahl belegter Betten'
FROM 
	patient
WHERE 
	aufnahmedatum BETWEEN '2022-12-25 00:00:00' AND '2022-12-25 23:59:59';

-- INNER JOIN (Alle Patienten mit dazugehörigen relevanten Informationen wie Bett, Status, Namen usw)
SELECT
	p1.personID AS PersonID,
	Vorname,
	Nachname,
	p1.bettID AS BettID,
	b.status AS Status,
	Aufnahmedatum,
	Entlassungsdatum
FROM
	patient p1
INNER JOIN
	person p2 ON p1.personID = p2.personID
INNER JOIN
	bett b ON p1.bettID = b.bettID;
    
-- LEFT JOIN (Alle Reinigungskräfte bzw alle Personen ohne Bett)
SELECT
	p1.personID AS PersonID,
	Vorname,
	Nachname,
	Geschlecht,
	Geburtsdatum
FROM
	person p1
LEFT JOIN
	patient p2 ON p1.personID = p2.personID
WHERE
	bettID IS NULL;
    
-- gebundene Sub-Query (Anzahl Reinigungen nach Aufnahme des Patienten)
SELECT
	p1.personID AS PersonID,
	Vorname,
	Nachname,
	Aufnahmedatum,
	(
	SELECT 
		COUNT(*)
	FROM 
		reinigung r
	WHERE 
		r.bettID = p1.bettID AND r.datum > p1.aufnahmedatum
	) AS 'Anzahl der Reinigungen nach Aufnahme des Patienten'
FROM
	patient p1
JOIN
	person p2 ON p1.personID = p2.personID;

-- ungebundene Sub-Query (Alle Betten, die noch nie belegt wurden)
SELECT
	bettID AS BettID, 
	status AS Status
FROM
	bett
WHERE 
	bettID NOT IN (SELECT 
			   bettID
		       FROM
			   patient);
    
--
-- Definition of all views
--

CREATE VIEW `Bett-Historie` AS
SELECT
	b.bettID AS `Bett-ID`,
	Vorname,
	Nachname,
	bezeichnung AS Raum,
	r2.datum AS Reinigungsdatum
FROM
	bett b
JOIN
	patient p1 ON (b.bettID = p1.bettID)
JOIN
	person p2 ON (p1.personID = p2.personID)
JOIN
	zuweisung z ON (b.bettID = z.bettID)
JOIN
	raum r1 ON (z.raumID = r1.raumID)
JOIN
	reinigung r2 ON (b.bettID = r2.bettID);

--
-- Definition of Stored Procedures
--

DELIMITER //

CREATE PROCEDURE InsertData(
	IN p_personID INT,
	IN p_bettID INT,
	IN p_datum DATE
)
BEGIN
	INSERT INTO Reinigung (personID, bettID, datum)
	VALUES (p_personID, p_bettID, p_datum);
END //

DELIMITER ;

--
-- Definition of User Rights
--

DROP USER IF EXISTS 'mitarbeiter'@'localhost';
CREATE USER 'mitarbeiter'@'localhost' IDENTIFIED BY 'password';

GRANT SELECT, UPDATE, DELETE, INSERT ON Bettenverwaltung.`Bett-Historie` TO 'mitarbeiter'@'localhost';
GRANT EXECUTE ON PROCEDURE bettenverwaltung.InsertData TO 'mitarbeiter'@'localhost';
