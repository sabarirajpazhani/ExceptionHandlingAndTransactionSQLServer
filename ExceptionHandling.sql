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

--ROLLBACK TRANSACTION and Understanding @@Error Global variable
begin transaction
	insert into Product values (106,'Product-6',600,35)
	insert into Product values(107,'Product-7',700,40)

	if(@@error > 0)
	begin
		rollback transaction
	end
	else
	begin
		commit transaction
	end

select * from Product;


--Types of Transactions in SQL Server
create table  Customer(
	CustomerID int Primary key,
	CustomerCode varchar(10),
	CustomerName varchar(50)
);
--1. Auto Commit Transaction Mode (default)
insert into Customer values(1, 'CODE_1', 'David');
--error
insert into Customer values(1, 'CODE_2', 'John');

--2. Implicit Transaction Mode in SQL Server
--------------------------
set implicit_transactions on

insert into Customer values(1, 'CODE_1', 'David');
insert into Customer values(2, 'CODE_2', 'John');

commit transaction
---------------------------
insert into Customer values(3, 'CODE_3', 'Pam')
update Customer set CustomerName = 'John Dewey' where CustomerID = 2;

select * from Customer ;
-----------------------------
rollback transaction

select * from Customer;
-----------------------------
--3. Explicit Transaction Mode in sql server
create procedure spAddCustomer
	@CustomerID int,
	@CustomerCode varchar(10),
	@CustomerName varchar(30)
as
begin
	begin transaction
	insert into Customer values (@CustomerID,@CustomerCode,@CustomerName);
	if (@@error > 0)
	begin
		rollback transaction
	end
	else 
	begin
		commit transaction
	end
end

spAddCustomer 103, 'CODE_3','Alice'

select * from Customer ;
