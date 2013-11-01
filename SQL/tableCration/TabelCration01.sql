USE dv1454_ht13_5

DROP TABLE accountholder
DROP TABLE account
DROP TABLE intrest
DROP TABLE acclog
DROP TABLE address
DROP TABLE aha


DROP TABLE accountholder
GO
CREATE TABLE accountholder(
	id INT IDENTITY(1,1),
	PRIMARY KEY(id),
	name VARCHAR(80),
	birthdate INT,
	telephone VARCHAR(20),
	email VARCHAR(225),
	pin INT	
)

DROP TABLE account
GO
CREATE TABLE account(
	id INT IDENTITY(1,1) PRIMARY KEY,
	balance float NOT NULL
)

DROP TABLE aha
GO
CREATE TABLE aha(
	ahID INT NOT NULL FOREIGN KEY REFERENCES accountholder(id),
	aID INT NOT NULL FOREIGN KEY  REFERENCES account(id),
	CONSTRAINT pk_aha PRIMARY KEY (ahID, aID)
) 

DROP TABLE address
GO
CREATE TABLE address(
	ahID INT NOT NULL FOREIGN KEY REFERENCES accountholder(id),
	address VARCHAR,
	postcode INT,
	city VARCHAR
	PRIMARY KEY (ahID)
)

DROP TABLE acclog
GO
CREATE TABLE acclog(
	id INT NOT NULL IDENTITY(1,1), 
	PRIMARY KEY(id),
	aID INT NOT NULL FOREIGN KEY REFERENCES account(id),
	ammount float NOT NULL,
	timestamp DATETIME
)

DROP TABLE intrest
GO
CREATE TABLE intrest(
	id INT NOT NULL IDENTITY(1,1), 
	PRIMARY KEY(id),
	aID INT NOT NULL FOREIGN KEY REFERENCES account(id),
	calculatedIntrest float NOT NULL,
	date DATETIME,
	
)

SELECT * FROM accountholder
SELECT * FROM account
SELECT * FROM acclog
SELECT * FROM address
SELECT * FROM intrest
