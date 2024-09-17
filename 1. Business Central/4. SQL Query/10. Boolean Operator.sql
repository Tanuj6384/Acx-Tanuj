
/* Boolean Operator */

CREATE TABLE userLogin
(
user_id INT PRIMARY KEY IDENTITY ,
userName VARCHAR(25) NOT NULL UNIQUE,
email VARCHAR(100) NOT NULL UNIQUE,
password VARCHAR(50) NOT NULL
);

INSERT INTO userLogin (userName,email,password) VALUES
('ironMan','ironman@gmail.com','ironman@123'),
('captain','captain@gmail.com','captain@123'),
('spidy','spidy@gmail.com','spidy@123'),
('wonder','wonder@gmail.com','wonder@123');

/*Find Username*/
SELECT userName FROM userLogin
WHERE email='ironman@gmail.com'
AND password='ironman@123';

/*Find Password*/
SELECT  password FROM userLogin
WHERE userName='wonder'
OR email='wonder@gmail.com';

/* Humko Wonder Nhi Chahiye Baki sab chahiye*/
SELECT * FROM userLogin
WHERE  NOT userName='wonder'
       /*OR*/
SELECT * FROM userLogin
WHERE userName !='wonder'

SELECT * FROM userLogin