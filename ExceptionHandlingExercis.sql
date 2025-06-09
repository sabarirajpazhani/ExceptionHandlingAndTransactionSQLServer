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
