--create database for Expectoin Handling Question
create database ExceptionHandlingExercise;

--use database 
use ExceptionHandlingExercise;

--create table
create table Employee(
	EmpID int primary key not null,
	EmpName varchar(80),
	EmpEmail varchar(80),
	EmpSalary int,
	EmpPhone varchar(20)
);

INSERT INTO Employee (EmpID,EmpName, EmpEmail, EmpSalary, EmpPhone) VALUES
(1,'Arun Kumar', 'arun.kumar@example.com', 45000, '9876543210'),
(2,'Balaji M', 'balaji.m@example.com', 52000, '8765432109'),
(3,'Charan R', 'charan.r@example.com', 61000, '7654321890'),
(4,'Deepika S', 'deepika.s@example.com', 47000, '9090909090'),
(5,'Ganesh K', 'ganesh.k@example.com', 58000, '9123456789');

select * from Employee;

drop table Employee;

/*1. Basic TRY...CATCH Block:
Write a script that inserts a record into a table and use a TRY...CATCH block to handle any errors.*/
begin try
	insert into Employee (EmpName,EmpEmail, EmpSalary, EmpPhone)
	values
	('Elango', 'Elango@gmail.com',85000, '9987875632');
end try
begin catch
	print 'Error Occurred : ' + ERROR_MESSAGE()
end catch

/*2. Handle Division by Zero:
Create a query that divides two numbers. Use TRY...CATCH to catch a "Divide by zero" error and print a custom message.*/
begin try
	declare @Number1 int = 180, @Number2 int = 0
	declare @Result int
	set @Result = @Number1 / @Number2
	print 'Result - ' + cast(@Result as varchar(30))
end try
begin catch
	print'Divide by Zero'
	print error_number()
end catch

/*3. Log Error Details:
Use ERROR_MESSAGE(), ERROR_LINE(), and ERROR_SEVERITY() inside a CATCH block to log complete error information into a separate ErrorLog table.*/
create table ErrorLog(
	ErrorMessage varchar(80),
	ErrorLine int,
	ErrorSeverity int,
);

drop table ErrorLog;

begin try
	declare @Num1 int = 100, @Num2 int = 0
	declare @Result1 int = 0
	set @Result1 = @Num1 /@Num2
	print 'Result - ' + cast(@Result1 as varchar(30))
	insert into Employee (EmpID, EmpName,EmpEmail, EmpSalary, EmpPhone) values
	(6,'Faizal', 'Faizal@gmail.com',85000,'77656523566')
	print 'Records are inserted Successfully'
end try
begin catch
	declare @Message varchar(80) = error_message()
	declare @Line int = error_line()
	declare @severity int = error_severity()
	insert into ErrorLog values
	(@Message, @Line, @severity);
end catch

select * from ErrorLog;

/*4. Nested TRY...CATCH:
Write a script with a nested TRY...CATCH structure where an inner error is caught and rethrown to the outer block.*/
begin try
	begin try
		select 100/0
		print 'Successfully Divided'
	end try
	begin catch 
		print 'Inner Catch '+ error_message()
		throw;
	end catch
end try
begin catch
	print 'Outter Catch '+ error_message()
end catch

/*5. RAISEERROR with Custom Message:
Use RAISEERROR inside the CATCH block to throw a user-defined error with severity level 16 and log it.*/
begin try
	declare @nums1 int = 150, @nums2 int = 0, @Result2 int = 0
	set @Result2 = @nums1/@nums2;
	print 'Result - ' + cast(@Result2 as varchar(30))
end try
begin catch
	insert into ErrorLog values
	(ERROR_MESSAGE(), ERROR_LINE(), ERROR_SEVERITY())
end catch

select * from ErrorLog;


/*6. Transaction Rollback on Error:
Simulate a transaction with multiple inserts, then force an error. Use TRY...CATCH to roll back the transaction and print "Transaction rolled back due to error."*/
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Employee (EmpName, EmpEmail, EmpSalary, EmpPhone) 
    VALUES ('Raj', 'Raj@gmail.com', 75000, '9987875678');

    INSERT INTO Employee (EmpName, EmpEmail, EmpSalary, EmpPhone) 
    VALUES (NULL, 'Ravi@gmail.com', 80000, '776765677');  -- This will cause error if EmpName is NOT NULL

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    PRINT 'Error: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
END CATCH;

/*7. Stored Procedure with Exception Handling:
Create a stored procedure that performs insert/update and includes error handling using TRY...CATCH.*/
create procedure spInsert
	@EmpName varchar(80) ,
	@EmpEmail varchar(80),
	@EmpSalary int,
	@EmpPhone varchar(20)
as
begin
	begin try
		insert into Employee values
		(@EmpName,@EmpEmail,@EmpSalary,@EmpPhone)
	end try
	begin catch
		Print 'Error ' + error_message()
	end catch
end

/* 8.Savepoint with Error Recovery:
Use SAVE TRANSACTION and simulate an error after it. Rollback to the savepoint and continue the transaction.*/
begin transaction
save transaction savePoint1
begin try
	insert into Employee
	values ('Thamizh','Thamizh@gmail.com',80000,'9987875678')
	Declare @Result3 int = 100/0
	print 'Result - '+cast(@Result3 as varchar(80))
end try
begin catch
	rollback transaction savePoint1
	print 'Error - ' + error_message()
end catch
commit transaction

select * from Employee;

/*9. Check @@ERROR (Legacy Style):
Write a script using the legacy @@ERROR method to handle errors after each SQL statement and print error status.*/
declare @error int

insert into Employee values
(null, 'Karthik', 'Karthik@gmail.com',86000,'9954324545')

set @error = @@error
if @error<> 0
print 'Error occurred in the code - ' + cast(@error as varchar(90))
else
print 'Inserted Successfully'

/*10. Custom Error with THROW:
Write a query using THROW 50001, 'Custom error occurred', 1 to manually raise an exception and handle it.*/
begin 
	declare @n1 int = 90, @n2 int = 0, @Result4 int =0
	begin try
		set @Result4 = @n1/@n2
		if @@error > 0
			throw 50001, 'Divison must not be Zero', 1
		else
			print 'Successfully Divided'
	end try
	begin catch
		print 'Error - ' + error_message()
	end catch
end
