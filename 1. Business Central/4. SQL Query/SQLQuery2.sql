CRAETE TABLE SYNTAX::::::::::::
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype,
   ....
);

CREATE TABLE AcxEmployeeMaster
(
EmployeeCode NVARCHAR(20) PRIMARY KEY,
EmployeeName VARCHAR(75),
);



INSERT SYNTAX::
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

INSERT INTO AcxEmployeeMaster VALUES('Emp011', 'Tanuj Sharma');
INSERT INTO AcxEmployeeMaster VALUES('Emp012', 'Pankaj Kumar');
INSERT INTO AcxEmployeeMaster VALUES('Emp013', 'Ankit Mishra');
INSERT INTO AcxEmployeeMaster VALUES('Emp014', 'Arush Sharma');
INSERT INTO AcxEmployeeMaster VALUES('Emp015', 'Manoj Tiwari');
INSERT INTO AcxEmployeeMaster VALUES('Emp016', 'Praney Singh');
INSERT INTO AcxEmployeeMaster VALUES('Emp017', 'Anurag Sharma');
INSERT INTO AcxEmployeeMaster VALUES('Emp018', 'Manish Kumar');
INSERT INTO AcxEmployeeMaster VALUES('Emp019', 'Pankaj Gupta');
INSERT INTO AcxEmployeeMaster VALUES('Emp020', 'Vivek kumar');



 CREATE TABLE AcxEmployeeAddress
 (
 EmployeeCode NVARCHAR(20),
 Address NVARCHAR(30), 
 City NVARCHAR(20),
 State NVARCHAR(200),
 Country NVARCHAR(20),
 IsPrimary INT
 )

 INSERT INTO AcxEmployeeAddress VALUES
 ('Emp011','A-70 NandGram','Ghaziabad','U.P','India',1),
 ('Emp011','D-7 Sihani Road','Khyala','Delhi','India',0),
 ('Emp012','A-22 NandGram','Ghaziabad','U.P','India',1 ),
 ('Emp012','C-26 Begumpur','Rithala','Delhi','India',0 ),
 ('Emp013','G-12 Meerut Road','Nandgram','Ghaziabad','India',1),
 ('Emp013', 'B-126 Gokul Mandir','Rama Vihar','Delhi','India',0 ),
 ('Emp014', 'D-56','Sec-6','Noida','India',1 ),
 ('Emp014','C-26 sabzi Mandi','PeeraGhari','Delhi','India',0),
 ('Emp015','F-13 Ghukna Road','Sihani','Ghaziabad','India',1),
 ('Emp015','R-198','Mohan Nagar','Ghaziabad','India',0 ),
 ('Emp016','G-55','Maxica','Jicun','London',0 ),
 ('Emp017','K-18','Kavi Nagar','Ghaziabad','India',0 ),
 

 SELECT E.EmployeeCode, E.EmployeeName, D.DateOfBirth, D.DateOfJoining, D.PhoneNumber, D.PAN, D.FatherName, A.Address, A.City, A.State, A.Country
FROM AcxEmployeeMaster AS E
JOIN AcxEmployeeDetails AS D ON E.EmployeeCode = D.EmployeeCode
LEFT JOIN AcxEmployeeAddress AS A ON E.EmployeeCode = A.EmployeeCode AND A.IsPrimary = 1 
ORDER BY E.EmployeeCode ;


 SELECT EmployeeCode,DateOfBirth,DateOfJoining,PhoneNumber,PAN,FatherName FROM AcxEmployeeDetails;

       SELECT ed.EmployeeCode,em.EmployeeName,ed.DateOfBirth,ed.DateOfJoining,ed.PhoneNumber,ed.PAN,ed.FatherName
              FROM  em JOIN AcxEmployeeDetails ed
              ON em.EmployeeCode=ed.EmployeeCode;


 5 AL ADD PRI ADD    10RECORDS 1
 3 EMP NO REC
 2 EMP 2NDRY ADREE IS PRIMAY 0


 select * from AcxEmployeeMaster;
 select * from AcxEmployeeDetails;
 select * from AcxEmployeeAddress;