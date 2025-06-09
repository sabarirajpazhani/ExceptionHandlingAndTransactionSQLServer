--create database for Expectoin Handling Question
create database ExceptionHandlingExercise;

--use database 
use ExceptionHandlingExercise;

--create table
create table Employee(
	EmpID int identity(1,1) primary key,
	EmpName varchar(80),
	EmpEmail varchar(80),
	EmpSalary int,
	EmpPhone varchar(20)
);

INSERT INTO Employee (EmpName, EmpEmail, EmpSalary, EmpPhone) VALUES
('Arun Kumar', 'arun.kumar@example.com', 45000, '9876543210'),
('Balaji M', 'balaji.m@example.com', 52000, '8765432109'),
('Charan R', 'charan.r@example.com', 61000, '7654321890'),
('Deepika S', 'deepika.s@example.com', 47000, '9090909090'),
('Ganesh K', 'ganesh.k@example.com', 58000, '9123456789');

select * from Employee;


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

/*RAISEERROR with Custom Message:
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
