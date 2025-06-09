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

--Nested Transactions in SQL Server
begin transaction T1
	insert into Customer values (3, 'CODE_3','Arun')
	insert into Customer values (4,'CODE_4','Balaji')

	begin transaction T2
		insert into Customer values (5,'CODE_5','Charan')
		insert into Customer values (6, 'CODE_6','Dhinesh')
		print @@trancount
	commit transaction T2
	print @@trancount
commit transaction T1
print @@trancount

select * from Customer;


--savepoint
delete from Customer;

begin transaction
	save transaction savepoint1
		insert into Customer values (1, 'CODE_1', 'Arun')
		insert into Customer values (2, 'CODE_2', 'Balaji')
	save transaction savepoint2
		insert into Customer values (3, 'CODE_3', 'Charan')
		insert into Customer values (4, 'CODE_4', 'Danush')
	save transaction savepoint3
		insert into Customer values (5, 'CODE_5', 'Elango')
		insert into Customer values (6, 'CODE_6', 'Faizel')

rollback transaction savepoint3;

select * from Customer;	


--savepint with nested transaction
delete from Customer;

begin transaction T1
	save transaction savepoint1
		insert into Customer values (1, 'CODE_1','Arun')
		insert into Customer values (2, 'CODE_2','Balaji')
	begin transaction T2
	save transaction savepoint2
		insert into Customer values (3, 'CODE_3','Charan')
		insert into Customer values (4, 'CODE_4', 'Dhanush')
	commit transaction T2
	rollback transaction savepoint2
commit transaction T1;



--------------------------------------------------------------------
--Exception Handling
--Exception Handling Using RAISERROR System Function in SQL Server
Alter procedure spAddNum1Num2
	@Number1 int,
	@Number2 int
as
begin
	set nocount on;
	declare @Result int
	if(@Number2 = 0)
	begin
		raiserror('Number2 must not be Zero',16,1);
		return
	end
	else
	begin
		set @Result = @Number1 + @Number2
		print 'Result = ' + cast(@Result as varchar(30))
	end
end;

spAddNum1Num2 200, 10;
		

-- Raise Error using RAISERROR statement in SQL Server
create procedure spAddtwoNum
	@Number1 int,
	@Number2 int
as
begin
	declare @Result int
	set @Result = 0
	begin try
		if @Number2 = 1
		raiserror('Number2 is not One',16,1)
		set @Result = @Number1 + @Number2
		print 'Result = ' + cast(@Result as varchar(30))
	end try
	begin catch 
		print error_number()
		print error_message()
		print error_severity()
		print error_state()
	end catch
end

spAddtwoNum 100, 1;


-- 1. Raise Error using throw statement in SQL Server.
create procedure spDevidedBy2
	@Number1 int,
	@Number2 int
as
begin
	declare @Result int
	set @Result = 0
	begin try
		if @Number2 = 2
		throw 50001,'Divisor must not be 2',1
		set @Result = @Number1 / @Number2
		print 'Result = ' + cast(@Result as varchar(30))
	end try
	begin catch 
		print error_number()
		print error_message()
		print error_severity()
		print error_state()
	end catch
end

spDevidedBy2 100,2

-- 2. Raise Error using throw statement in SQL Server.
create procedure spDiviedByZero
	@Number1 int,
	@Number2 int
as
begin
	declare @Result int
	set @Result = 0
	begin try
		if (@Number2 = 0)
		throw 50001, 'Divisor must not be Zero', 1
		set @Result = @Number1 /@Number2
		print 'Result - ' + cast(@Result as varchar(30))
	end try
	begin catch 
		print error_number()
		print error_message()
		print error_severity()
		print error_state()
	end catch
end

spDiviedByZero 120, 0;
