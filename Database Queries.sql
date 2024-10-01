--Specifying the database to use 
Use AdventureWorks2022
--prints out all the details from specified column
Select * from [AdventureWorks2022].[Sales].[visits]

--Creating a tempTable---
Select BusinessEntityID, firstname, lastname, Title
into #tempPersonTable
from [Person].[Person]
where Title = 'mr.'

--dropping/deleting table
drop table #tempPersonTable

Select BusinessEntityID, firstname, lastname, Title
from [Person].[Person]
where Title = 'mr.'

Select * from #tempPersonTable

---Creating a view---
CREATE VIEW TempPerson AS
SELECT 
    Person.Person.Title,
    Person.Person.FirstName,
    Person.Person.LastName,
    Person.PersonPhone.PhoneNumber,
    Person.PhoneNumberType.Name AS PhoneType
FROM 
    Person.Person
INNER JOIN 
    Person.PersonPhone ON Person.Person.BusinessEntityID = Person.PersonPhone.BusinessEntityID
INNER JOIN 
    Person.PhoneNumberType ON Person.PersonPhone.PhoneNumberTypeID = Person.PhoneNumberType.PhoneNumberTypeID
WHERE 
    Person.Person.Title = N'Mr.';
	------Dealing with Select Statement
--View all details from view--
Select * from TempPerson
--Prints out all details from Person address table
Select * from Person.Address
--Selecting specified columns from table
Select addressid, city, modifieddate from Person.Address
--Selecting top 10
Select Top 10 * from Person.Address
--Operators 
Select * from Person.Address where PostalCode = '98011'
Select * from Person.Address where PostalCode != '98011'
Select * from Person.Address where PostalCode <> '98011'
Select count(*) from Person.Address where PostalCode <> '98011'
Select * from Person.Address where ModifiedDate = '2008-12-19 00:00:00.000'
Select * from Person.Person where FirstName like 'Mat%'
Select * from HumanResources.EmployeePayHistory
Select Max(Rate) from HumanResources.EmployeePayHistory
Select Max(Rate) As PayRate from HumanResources.EmployeePayHistory
Select Min(Rate) from HumanResources.EmployeePayHistory
Select * from Production.ProductCostHistory where StartDate = '2013-05-30 00:00:00.000' 
Select * from Production.ProductCostHistory where StartDate = '2013-05-30  00:00:00.000' And StandardCost >= 200.00
Select * from Production.ProductCostHistory where StartDate = '2013-05-30  00:00:00.000' And StandardCost >= 200.00 Or ProductID > 800
Select * from Production.ProductCostHistory where ProductID in (802, 803,820, 900)
Select * from Production.ProductCostHistory where EndDate IS NULL
Select * from Production.ProductCostHistory where EndDate IS Not Null

---OrderBy Clauses
Select * From [HumanResources].EmployeePayHistory order by Rate
Select * From HumanResources.EmployeePayHistory order by rate ASC
Select * From HumanResources.EmployeePayHistory order by rate ASC
Select * From HumanResources.EmployeePayHistory where ModifiedDate >= '2010-06-30 00:00:00.000' order by ModifiedDate Desc
Select * From HumanResources.EmployeePayHistory where YEAR(ModifiedDate) >= 2014 order by ModifiedDate DESC
Select * From HumanResources.EmployeePayHistory where Month(ModifiedDate) >= '06' order by ModifiedDate DESC
---GroupBy Clause
Select COUNT(*) from Person.Address Where PostalCode = '98011'
Select * From Person.Address where PostalCode = '98011'
Select COUNT(*) from Person.Address Where PostalCode = '98225'
Select COUNT(*) as CountAddress, PostalCode from Person.Address Group By PostalCode order by PostalCode Desc
Select Count(*) as CountCity,City from Person.Address group by City order by City DESC 

----Group by and Having Clause
Select * from Production.Product
Select COUNT(1) As CountOfProduct, Color from Production.Product where Color = 'yellow' group by Color
Select COUNT(1) As CountOfProduct, Color from Production.Product group by Color Having Color = 'yellow'
Select COUNT(1) As CountOfProduct, Color, Size from Production.Product group by Color, Size Having SIZE >= '44'
--Create Table 
Create Table EmployeeDB(
EmpId int primary key,
EmpName varchar (255),
EmpTitle varchar(255)
)
Create Table SalesDB(
SalesNum int primary key,
EmpID int , 
EmpName varchar (255),
itemSold int,
Foreign key(EmpId) references EmployeeDB (EmpId)
)
-- Inserting data into EmployeeDB
INSERT INTO EmployeeDB (EmpId, EmpName, EmpTitle) VALUES 
(1, 'Alice Johnson', 'Sales Manager'),
(2, 'Bob Smith', 'Sales Associate'),
(3, 'Charlie Brown', 'Sales Representative');

-- Inserting data into SalesDB
INSERT INTO SalesDB (SalesNum, EmpId, EmpName, ItemSold) VALUES 
(101, 1, 'Alice Johnson', 10),
(102, 2, 'Bob Smith', 5),
(103, 3, 'Charlie Brown', 8),
(104, 1, 'Alice Johnson', 7);

--Join table 
Select e.EmpId,e.EmpName,e.EmpTitle, s.itemSold
from EmployeeDB e
Join SalesDB s
on e.EmpId = s.EmpID

Select e.EmpId,e.EmpName,e.EmpTitle, s.itemSold
from EmployeeDB e
Join SalesDB s
on e.EmpId = s.EmpID
order by e.EmpId

Select count(s.SalesNum) as SalesCount,e.EmpId,e.EmpName
from EmployeeDB e
Join SalesDB s
on e.EmpId = s.EmpID
group by e.EmpId, e.EmpName

--Creating sample tables to demonstrate diff. types of joins
-- Drop tables if they exist
IF OBJECT_ID('dbo.Student', 'U') IS NOT NULL DROP TABLE dbo.Student;
IF OBJECT_ID('dbo.Course', 'U') IS NOT NULL DROP TABLE dbo.Course;

create table Course(
rollNum int primary key identity(1,1),
courseID int
) 

create table Student(
studentID int primary key identity(1,1) ,
rollNumber int,
studentName varchar(50),
studNum varchar(20),
studAge int,
Foreign Key(rollNumber) references Course(rollNum)
)

-- Populate the Course table with sample data
INSERT INTO Course (courseID) VALUES 
(101), (102), (103), (104), (105);

-- Populate the Student table with sample data, ensuring rollNumber matches rollNum in Course
INSERT INTO Student (rollNumber, studentName, studNum, studAge) VALUES 
(1, 'Alice Smith', 'S1001', 20),
(2, 'Bob Johnson', 'S1002', 21),
(3, 'Charlie Brown', 'S1003', 22),
(4, 'Daisy Miller', 'S1004', 19),
(5, 'Ethan Clark', 'S1005', 23);

Select * from Student
Select * from Course

SELECT * 
FROM Student s
INNER JOIN Course c ON s.rollNumber = c.rollNum;

Select s.rollNumber, s.studentName, c.courseID
from Student s
inner join Course c
on s.rollNumber = c.rollNum

Select *
from Student s
left join Course c
on s.rollNumber = c.rollNum

Select s.rollNumber, s.studentName, c.courseID
from Student s
right join Course c
on s.rollNumber = c.rollNum

Select s.rollNumber, s.studentName, c.courseID
from Student s
full join Course c
on s.rollNumber = c.rollNum

---Subquerying AdventureWorks Databases
Select * from AdventureWorks2022.HumanResources.EmployeePayHistory
Where BusinessEntityID in
(Select BusinessEntityID 
From HumanResources.EmployeePayHistory
where Rate > 60)

Select * from HumanResources.EmployeePayHistory
Where BusinessEntityID =
(Select BusinessEntityID 
From HumanResources.EmployeePayHistory
where Rate = 39.06)

--Subquerying from 2 tables
Select * from Production.Product
Where ProductID IN
(Select ProductID
From Production.ProductInventory
where Quantity >= 300)