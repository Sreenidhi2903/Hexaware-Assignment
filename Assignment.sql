--TASK 1 Database Design:
--Database Schema and Sample Data

-- User Table
Create Table [User] (
    UserID int Primary key,
    Name Varchar(255),
    Email Varchar(255) Unique,
    Password Varchar(255),
    ContactNumber Varchar(20),
    Address Text
);
Insert into [User] Values (1, 'nidhi', 'nidhi@gmail.com', 'pass123', '9277896539', 'Nizamabad'),
(2, 'Pranu', 'pranu@gmail.com', 'pass456', '9123456789', 'Anantapur'),
(3, 'Chitti', 'chitti@gmail.com', 'pass789', '9299896539', 'Banglore'),
(4, 'Sree', 'sree@gmail.com', 'pass101', '9277808539', 'Madurai'),
(5, 'Riddhi', 'riddhi@gmail.com', 'pass121', '9277845539', 'Kamareddy');
select*from [User]
-- CourierServices Table
Create Table CourierServices (
    ServiceID int Primary key ,
    ServiceName Varchar(100),
    Cost Decimal(8, 2)
);
Insert into CourierServices Values (1, 'Standard Delivery', 50.00),
(2, 'Express Delivery', 100.00);
select * from CourierServices;
-- Courier Table
CREATE TABLE Courier (
    CourierID INT PRIMARY KEY,
    SenderName VARCHAR(255),
    SenderAddress TEXT,
    ReceiverName VARCHAR(255),
    ReceiverAddress TEXT,
    Weight DECIMAL(5, 2),
    Status VARCHAR(50),
    TrackingNumber VARCHAR(20) UNIQUE,
    DeliveryDate DATE,
    CreatedDate DATE,
    ServiceID INT,
    DeliveredByEmployeeID INT,
    UserID INT,
    FOREIGN KEY (ServiceID) REFERENCES CourierServices(ServiceID),
    FOREIGN KEY (DeliveredByEmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);
Insert into Courier Values (101, 'nidhi', 'Nizamabad', 'prashu', 'KYL', 2.5, 'In Transit', 'T1', '2025-06-20','2025-06-10',1, 1, 1),
(102, 'pranu', 'Anantapur', 'Deepthi', 'KLD', 1.5, 'Delivered', 'T2', '2025-06-15','2025-06-08',2, 2, 2),
(103, 'Chitti', 'Hyderabad', 'prakash', 'MTPLY', 2.0, 'Delivered', 'T3', '2025-06-24','2025-06-15',1, 3, 3),
(104, 'Sree', 'MDU', 'Siddhi', 'ONG', 1.5, 'Cancelled', 'T4', '2025-06-10','2025-06-1',2, 4, 4),
(105, 'Riddhi', 'Nellore', 'Koumi', 'KMR', 1.0, 'Cancelled', 'T5', '2025-06-22','2025-06-20',1, 5, 5);
select * from Courier;
-- Employee Table
Create Table Employee (
    EmployeeID Int Primary Key,
    Name Varchar(255),
    Email Varchar(255) Unique,
    ContactNumber Varchar(20),
    Role Varchar(50),
    Salary Decimal(10, 2)
);
Insert into Employee Values (1, 'Krish', 'krish@gmail.com', '9988776655', 'Delivery Boy', 25000.00),
(3, 'John', 'john@gmail.com', '8765455678', 'Delivery boy', 25000.00),(2, 'Koumi', 'koumi@gmail.com', '8877665544', 'Manager', 50000.00);
Insert into Employee Values (4, 'Krishna', 'krishna@gmail.com', '9989776655', 'Delivery Boy', 25000.00),(5, 'Varun', 'varun@gmail.com', '9988773455', 'Employee', 28000.00);
select * from Employee

-- Location Table
Create Table Location (
    LocationID Int Primary Key,
    LocationName Varchar(100),
    Address Text
);
Insert Into Location Values (1, 'Main Office', 'Hitex City'),
(2, 'Branch Office', 'Whitefield');
select * from Location
-- Payment Table
Create Table Payment (
    PaymentID Int Primary Key,
    CourierID Int,
    LocationID Int,
    Amount Decimal(10, 2),
    PaymentDate Date,
    Foreign Key (CourierID) References Courier(CourierID),
    Foreign Key (LocationID) References Location(LocationID)
);
Insert into Payment Values (1, 101, 1, 50.00, '2025-06-14'),
(2, 102, 2, 100.00, '2025-06-12'),(3, 103, 1, 50.00, '2025-06-18'),
(4, 104, 2, 500.00, '2025-06-20'),(5, 105, 1, 200.00, '2025-06-22');
select * from Payment
-- TASK 2 Select,Where

Select * from [user]

Select * from Courier Where UserID = 1;

select * from courier

Select * from Courier Where CourierID = 101;

Select * from Courier Where CourierID = 101;

Select * from Courier Where Status != 'Delivered';

Select * from Courier Where DeliveryDate = Cast(getdate() AS date);

Select * from Courier Where Status = 'In Transit';

Select UserID, Count(*) AS TotalPackages from Courier
Group by UserID;

Select UserID, AVG(datediff(DAY, CreatedDate, DeliveryDate)) AS AvgDeliveryDays from Courier
Group By UserID;

Select * from Courier Where Weight between 1 AND 3;

Select * from Employee Where Name like'%John%';

Select c.* from Courier c Join Payment p ON c.CourierID = p.CourierID
Where p.Amount > 50;


--TASK 3 GroupBy, Aggregate Functions, Having, Order By, where  

Select e.EmployeeID, e.Name, COUNT(c.CourierID) AS TotalCouriers
from Employee e
JOIN Courier c ON e.EmployeeID = c.DeliveredByEmployeeID
GROUP BY e.EmployeeID, e.Name;

Select DeliveredByEmployeeID, COUNT(*) AS TotalCouriers
from Courier
GROUP BY DeliveredByEmployeeID;

Select LocationID, SUM(Amount) AS TotalRevenue
from Payment
GROUP BY LocationID;

Select LocationID, COUNT(*) AS TotalCouriers
from Payment
GROUP BY LocationID;

Select top 1 CourierID, AVG(DATEDIFF(DAY, CreatedDate, DeliveryDate)) AS AvgDeliveryDays
from Courier
GROUP BY CourierID
ORDER BY AvgDeliveryDays DESC;

select LocationID, SUM(Amount) AS TotalAmount
from Payment
GROUP BY LocationID
HAVING SUM(Amount) < 1000;

Select LocationID, SUM(Amount) AS TotalPayments
from Payment
GROUP BY LocationID;

Select CourierID, SUM(Amount) AS Total
from Payment
Where LocationID = 1
GROUP BY CourierID
HAVING SUM(Amount) > 1000;

Select CourierID, SUM(Amount) AS Total
from Payment
Where PaymentDate > '2025-06-01'
GROUP BY CourierID
HAVING SUM(Amount) > 1000;

select LocationID, SUM(Amount) AS Total
from Payment
Where PaymentDate < '2025-06-20'
GROUP BY LocationID
HAVING SUM(Amount) > 5000;

-- TASK 4: Inner Join,Full Outer Join, Cross Join, Left Outer Join,Right Outer Join 
Select P.*, C.*
from Payment P
INNER JOIN Courier C ON P.CourierID = C.CourierID;

select P.*, L.*
from Payment P
INNER JOIN Location L ON P.LocationID = L.LocationID;

Select P.*, C.TrackingNumber, L.LocationName
from Payment P
INNER JOIN Courier C ON P.CourierID = C.CourierID
INNER JOIN Location L ON P.LocationID = L.LocationID;

Select P.*, C.*
from Payment P
INNER JOIN Courier C ON P.CourierID = C.CourierID;

select CourierID, SUM(Amount) AS TotalPayments
from Payment
GROUP BY CourierID;

Select * FROM Payment
Where PaymentDate = '2025-06-12';

Select P.*, C.*
from Payment P
INNER JOIN Courier C ON P.CourierID = C.CourierID;

Select P.*, L.*
From Payment P
INNER JOIN Location L ON P.LocationID = L.LocationID;

Select CourierID, SUM(Amount) AS TotalPayments
from Payment
GROUP BY CourierID;

Select * FROM Payment
Where PaymentDate BETWEEN '2025-06-01' AND '2025-06-21';

Select U.*, C.*
from [User] U
FULL OUTER JOIN Courier C ON U.UserID = C.UserID;

Select C.*, CS.*
from Courier C
FULL OUTER JOIN CourierServices CS ON C.ServiceID = CS.ServiceID;

select E.*, P.*
from Employee E
FULL OUTER JOIN Courier C ON E.EmployeeID = C.DeliveredByEmployeeID
FULL OUTER JOIN Payment P ON C.CourierID = P.CourierID;

Select * from [User]
CROSS JOIN CourierServices;

Select * from Employee
CROSS JOIN Location;

Select CourierID, SenderName, SenderAddress
from Courier;

Select CourierID, ReceiverName, ReceiverAddress
from Courier;

Select C.*, CS.ServiceName, CS.Cost
from Courier C
LEFT JOIN CourierServices CS ON C.ServiceID = CS.ServiceID;

Select E.EmployeeID, E.Name, COUNT(C.CourierID) AS TotalCouriers
from Employee E
LEFT JOIN Courier C ON E.EmployeeID = C.DeliveredByEmployeeID
GROUP BY E.EmployeeID, E.Name;

Select L.LocationID, L.LocationName, SUM(P.Amount) AS TotalPayments
from Location L
LEFT JOIN Payment P ON L.LocationID = P.LocationID
GROUP BY L.LocationID, L.LocationName;

SELECT * FROM Courier
WHERE SenderName = 'nidhi';

SELECT Role, COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY Role
HAVING COUNT(*) > 1;

SELECT P.*
FROM Payment P
JOIN Courier C ON P.CourierID = C.CourierID
WHERE CAST(C.SenderAddress AS VARCHAR(MAX)) LIKE 'Nizamabad'

SELECT * FROM Courier
WHERE CAST(SenderAddress AS VARCHAR(MAX)) = 'Nizamabad'

SELECT E.EmployeeID, E.Name, COUNT(C.CourierID) AS TotalCouriers
FROM Employee E
LEFT JOIN Courier C ON E.EmployeeID = C.DeliveredByEmployeeID
GROUP BY E.EmployeeID, E.Name;

SELECT C.CourierID, SUM(P.Amount) AS Paid, CS.Cost
FROM Courier C
JOIN CourierServices CS ON C.ServiceID = CS.ServiceID
JOIN Payment P ON C.CourierID = P.CourierID
GROUP BY C.CourierID, CS.Cost
HAVING SUM(P.Amount) > CS.Cost;

--Scope: Inner Queries, Non Equi Joins, Equi joins,Exist,Any,All 
SELECT * FROM Courier
WHERE Weight > (SELECT AVG(Weight) FROM Courier);

SELECT * FROM Employee
WHERE Salary > (SELECT AVG(Salary) FROM Employee);

SELECT SUM(Cost) AS TotalCost
FROM CourierServices
WHERE Cost < (SELECT MAX(Cost) FROM CourierServices);

SELECT DISTINCT C.CourierID,C.SenderName,CAST(C.SenderAddress AS VARCHAR(MAX)) AS SenderAddress,C.ReceiverName,
CAST(C.ReceiverAddress AS VARCHAR(MAX)) AS ReceiverAddress,C.Weight,C.Status,C.TrackingNumber,C.DeliveryDate,
C.CreatedDate,C.ServiceID,C.DeliveredByEmployeeID,C.UserID
FROM Courier C
JOIN Payment P ON C.CourierID = P.CourierID;

SELECT LocationID, Amount
FROM Payment
WHERE Amount = (SELECT MAX(Amount) FROM Payment);

SELECT * FROM Courier
WHERE Weight > ALL (
SELECT Weight FROM Courier WHERE SenderName = 'nidhi')

ALTER TABLE Courier
ADD CourierStaffId INT;

select * from Courier
UPDATE Courier SET CourierStaffId = 1001 WHERE TrackingNumber = 'T1';
UPDATE Courier SET CourierStaffId = 1002 WHERE TrackingNumber = 'T2';
UPDATE Courier SET CourierStaffId = 1003 WHERE TrackingNumber = 'T3';
UPDATE Courier SET CourierStaffId = 1002 WHERE TrackingNumber = 'T4';
UPDATE Courier SET CourierStaffId = 1001 WHERE TrackingNumber = 'T5';
UPDATE Courier SET CourierStaffId = 1001 WHERE CourierStaffName = 'koumi';

ALTER TABLE Courier
ADD CourierStaffName VARCHAR(100);

UPDATE Courier SET CourierStaffName = 'nidhi' WHERE CourierStaffId = 1001;
UPDATE Courier SET CourierStaffName = 'chitti' WHERE CourierStaffId = 1002;
UPDATE Courier SET CourierStaffName = 'sree' WHERE CourierStaffId = 1003;
UPDATE Courier SET CourierStaffName = 'koumi' WHERE CourierID = 999;


