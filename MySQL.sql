CREATE database Sbase;
DROP DATABASE Sbase;
CREATE database IF NOT exists Sbase;
DROP DATABASE IF exists Sbase;
CREATE database Sbase collate utf8_general_ci;
SHOW DATABASES;
USE Sbase;



CREATE TABLE A
(
	id INT NOT NULL auto_increment,
	name VARCHAR(30) NOT NULL DEFAULT '',
	cash FLOAT NOT NULL DEFAULT 0,
	PRIMARY KEY (id)
);
DESCRIBE A;
DROP table A;
CREATE TABLE B LIKE A;
DROP TABLE IF exists B;
CREATE TABLE B 
	SELECT * FROM A;
CREATE temporary table C
	SELECT * FROM A;
DROP temporary table c;



ALTER TABLE A DROP COLUMN cash;
ALTER TABLE A MODIFY name CHAR(30);
ALTER TABLE A CHANGE name newname CHAR(30);
ALTER TABLE A ADD COLUMN cash FLOAT NOT NULL DEFAULT 0;



CREATE INDEX iname ON A (newname);
DROP INDEX iname ON A;
CREATE TABLE dir
(
	id INT NOT NULL,
	PRIMARY KEY(id)
);
CREATE TABLE D
(
	id INT NOT NULL auto_increment,
	name VARCHAR(30) NOT NULL DEFAULT '',
	direction INT NOT NULL,
	cash FLOAT NOT NULL DEFAULT 0,
	CONSTRAINT cname UNIQUE KEY(name),
	FOREIGN KEY(direction) references dir(id),
	PRIMARY KEY (id),
	INDEX iname (name)
);



INSERT INTO a
	VALUES (NULL, 'value1', 12.3);
INSERT INTO a (newname, cash)
	VALUES ('value2', 32.22);
INSERT INTO a (newname, cash)
	VALUES ('value3', 3.2),
			('value4', 7.42),
			('value5', 66.1);
INSERT IGNORE INTO a
	VALUES (6, 'value3', 3.2),
			(6, 'value4', 7.42),
			(7, 'value5', 66.1);
INSERT INTO a (newname, cash)
	SELECT newname, cash FROM a;

LOAD data
	INFILE 'C:/test/test.txt'
	INTO TABLE a
	FIELDS TERMINATED by '\t'
LINES TERMINATED BY '\r\n';

DELETE FROM a
	WHERE id = 1;
DELETE FROM a
	ORDER BY id DESC
	LIMIT 1;

UPDATE a
	SET newname = 'nNValue',
	cash = cash * 1.2
WHERE id = 33;



SELECT * FROM a;
SELECT newname, cash FROM a;
SELECT newname, cash FROM a LIMIT 2;
SELECT newname, cash FROM a LIMIT 2,2;
SELECT newname, cash FROM a WHERE id > 3;
SELECT newname FROM a WHERE newname = 'value4';
SELECT DISTINCT newname FROM a WHERE newname = 'value4';
SELECT newname FROM a WHERE id BETWEEN 3 AND 6;
SELECT newname FROM a WHERE cash LIKE '%66%';



CREATE TABLE fit
(
	id INT NOT NULL auto_increment,
	text TEXT,
	PRIMARY KEY (id)	
);
CREATE FULLTEXT INDEX ixFT ON fit(text);
INSERT INTO fit (text)
	VALUES ('Cactus rode on horseback,
				led dog Shoulder ...'),
			('Cactus rode on horseback,
				...'),
			('Cactus .. dog...');
SELECT * FROM fit
WHERE MATCH(text) 
	AGAINST('dog' IN NATURAL LANGUAGE MODE);
SELECT * FROM fit
WHERE MATCH(text) 
	AGAINST('+horseb* -dog' IN BOOLEAN MODE);



SELECT SUM(cash) FROM a;
SELECT COUNT(newname) FROM a;
SELECT COUNT(distinct newname) FROM a;
SELECT GROUP_CONCAT(newname) FROM a;
SELECT MAX(cash) FROM a;
SELECT MIN(cash) FROM a;



SELECT newname, SUM(cash) from a
GROUP BY newname;
SELECT newname, SUM(length(newname)) from a
GROUP BY newname;
SELECT newname, SUM(length(newname)) from a
GROUP BY newname
HAVING SUM(length(newname)) <= 12 ;



CREATE TABLE peoples (Name VARCHAR(20), DepID INT);
CREATE TABLE department (Dep CHAR(2), DepID INT);
INSERT INTO peoples (Name, DepID)
	VALUES ('Alex', 1),
			('Dima', 1),
			('Ira', 2),
			('Vika', 2),
			('Igor', 3),
			('Lex', 5);
INSERT INTO department (Dep, DepID)
	VALUES ('IT', 1),
			('MN', 2),
			('HR', 3),
			('TD', 4);
SELECT peoples.Name, department.Dep
FROM peoples
	INNER JOIN department ON 
		peoples.DepID = department.DepID;
SELECT peoples.Name, department.Dep
FROM peoples
	LEFT OUTER JOIN department ON 
		peoples.DepID = department.DepID;
SELECT peoples.Name, department.Dep
FROM peoples
	RIGHT OUTER JOIN department ON 
		peoples.DepID = department.DepID;
SELECT peoples.Name, department.Dep
FROM peoples
	RIGHT OUTER JOIN department ON 
		peoples.DepID = department.DepID
WHERE department.DepID = 1;



CREATE VIEW tax_cash AS
	SELECT *, cash * 1.2 AS tax_cash
		FROM a;
SELECT * FROM tax_cash;
DROP VIEW tax_cash;



DELIMITER |
DROP PROCEDURE IF EXISTS proc |
CREATE PROCEDURE proc()
BEGIN
	SELECT * FROM a;
END;
|
DELIMITER ;
CALL proc();

DELIMITER |
DROP PROCEDURE IF EXISTS proc2 |
CREATE PROCEDURE proc2(IN pid INT)
BEGIN
	SELECT * FROM a WHERE id = pid;
END;
|
DELIMITER ;
CALL proc2(2);

DELIMITER |
DROP PROCEDURE IF EXISTS proc3 |
CREATE PROCEDURE proc3(OUT rcount INT)
BEGIN
	SELECT COUNT(*) INTO rcount FROM a;
END;
|
DELIMITER ;
CALL proc3(@rcount);
SELECT @rcount;

DELIMITER |
DROP PROCEDURE IF EXISTS proc4 |
CREATE PROCEDURE proc4(pid INT)
BEGIN
	DECLARE ppid INT DEFAULT 4;
	if(ppid > pid) THEN
		SELECT * FROM a WHERE id = pid;
	else
		SELECT 'Bad argument';
	END IF;
END;
|
DELIMITER ;
CALL proc4(6);

DELIMITER |
DROP FUNCTION IF EXISTS func |
CREATE FUNCTION func(pid INT) RETURNS VARCHAR(20)
BEGIN
	DECLARE ppid INT DEFAULT 4;
	if(ppid > pid) THEN
		RETURN 'Good_Argument';
	else
		RETURN 'Bad_Argument';
	END IF;
END;
|
DELIMITER ;
SELECT FUNC(7);



START transaction;
INSERT INTO a
	VALUES (555, '555', 555);
SELECT * FROM A WHERE id = 555;
ROLLBACK;
SELECT * FROM A WHERE id = 555;
INSERT INTO a
	VALUES (555, '555', 555);
COMMIT;
SELECT * FROM A WHERE id = 555;



CREATE USER 'test@localhost';
SET PASSWORD FOR 'test@localhost' = PASSWORD('password');

CREATE USER 'test2@%' IDENTIFIED BY 'password';
SELECT user, host FROM mysql.user; 

USE mysql;
UPDATE user set password = PASSWORD('123456') WHERE user = 'test';

GRANT SELECT, UPDATE, DELETE
	ON sbase.*
	TO 'test@localhost';
REVOKE DELETE
	ON sbase.*
	FROM 'test@localhost';
REVOKE ALL PRIVILEGES
	ON sbase.*
	FROM 'test@localhost';




