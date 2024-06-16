DROP DATABASE IF EXISTS `KHBib-DB`;
CREATE DATABASE `KHBib-DB`;
USE `KHBib-DB`;
CREATE TABLE Mitarbeiter(idMitarbeiter INT PRIMARY KEY AUTO_INCREMENT,
						 Vorname VARCHAR(30),
                         Nachname VARCHAR(30),
                         Geburtsdatum DATE
                         );
CREATE TABLE Buch(ISBN INT PRIMARY KEY,
				  Titel VARCHAR(30),
                  Autor VARCHAR(30),
                  Seitenzahl INT,
                  InhaltAlsPDF BOOL
                  );
CREATE TABLE Exemplar(ExemplarID INT PRIMARY KEY AUTO_INCREMENT,
					  Zustand VARCHAR(9),
                      Beschaffungsdatum DATE,
                      Preis DOUBLE,
                      BID INT,
                      FOREIGN KEY(BID) REFERENCES Buch(ISBN) ON DELETE CASCADE,
                      CONSTRAINT pruefeZustand
						CHECK(
							Zustand
								IN('Neu','Neuwertig','Gut','Gebraucht'))
                      );
CREATE TABLE Verleih(Verleihdatum DATE,
					 Rückgabedatum DATE,
                     Kosten DOUBLE,
                     AnzahlMahnungen INT,
                     MID INT,
                     EID INT,
                     FOREIGN KEY(MID) REFERENCES Mitarbeiter(idMitarbeiter),
					 FOREIGN KEY(EID) REFERENCES Exemplar(ExemplarID) ON DELETE CASCADE,
					 PRIMARY KEY(EID)
                     );
                     
INSERT INTO Buch(ISBN) VALUES(100);
INSERT INTO Exemplar(Preis, BID) VALUES(249.99,100), (19.99,100);
INSERT INTO Mitarbeiter(Vorname) VALUES('Tyga'), ('Vanilla');
INSERT INTO Verleih(Kosten, MID, EID) VALUES(49.99,1,1);
INSERT INTO Verleih(Kosten, MID, EID) VALUES(29.99,1,2);
SELECT * FROM Verleih;