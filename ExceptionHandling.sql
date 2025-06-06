--create database 
create database TransactionManagement;

--use database
use TransactionManagement;

--Create Product table
CREATE TABLE Product
(
 ProductID INT PRIMARY KEY, 
 Name VARCHAR(40), 
 Price INT,
 Quantity INT
 )
 GO

 -- Populate Product Table with test data
 INSERT INTO Product VALUES(101, 'Product-1', 100, 10)
 INSERT INTO Product VALUES(102, 'Product-2', 200, 15)
 INSERT INTO Product VALUES(103, 'Product-3', 300, 20)
 INSERT INTO Product VALUES(104, 'Product-4', 400, 25)

 SELECT *FROM product;

 --COMMIT transaction in SQL Server with DML statements
 begin transaction
	insert into Product values (105, 'Product-5',500,30)
	update Product set Price = 350 where ProductID = 103
	delete from Product where ProductID = 103
commit transaction