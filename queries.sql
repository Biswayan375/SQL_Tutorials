-- To create the table employee
create table employee(
	e_id varchar(5),
	name varchar(20),
	salary number(5),
	city varchar(10),
	dob date,
	primary key(e_id, name)
);

-- To insert values in it
insert into employee values('E07', 'Ajay', 3000, 'Kolkata', '12-JAN-00');
insert into employee values('E19', 'Bijay', 3219, 'Gurgaon', '01-JUL-10');
insert into employee values('E20', 'Roy', 5270, 'Kolkata', '18-FEB-12');
insert into employee values('E48', 'Ram', 4350, 'UP', '12-JAN-02');
insert into employee values('E13', 'Sam', 4100, 'Mumbai', '18-MAY-07');
insert into employee values('E14', 'Sunil', 4517, 'Gujrat', '16-JUN-1999');
insert into employee values('E50', 'Sunil', 4300, 'Kolkata', '12-AUG-2001');

-- Finding out the name of the employee who gets the maximum salary using subquery
select name as fullname from employee 
where
	salary = (select max(salary) from employee);
	
-- Finding out the 2nd highest paid employee
select * from employee
	where
		salary in(
			select max(salary) from employee
				where
					salary not in(
						select max(salary) from employee
					)
		);
		
-- Finding out the age of an employee
select trunc((sysdate-(select dob from employee where e_id='E07'))/365) as age_of_ajay from dual;

-- Showing name and ages of every employee
select name, (
	trunc(
		((select sysdate from dual)-dob)/365
	)
) as age from employee;

-- Finding the oldest employee in the company
	-- This query finds out the maximum age 
	select max(
		trunc(
			((select sysdate from dual)-dob)/365
		)
	) from employee;
	
	--Incorporating the above query with the main query to show all the details of the oldest employee that looks like: select * from employee where age = max(age);
	select * from employee where trunc(
			((select sysdate from dual)-dob)/365
		) = (select max(
		trunc(
			((select sysdate from dual)-dob)/365
		)
	) from employee);
	
-- Finding the oldest employee in the company in another shorter way
select * from 
	(select * from employee order by dob) 
	where rownum <= 1;

-- Find out the details of the employees who belongs to such cities from where greater than one employees belong to
select * from employee 
where city in(select city from employee group by city 
	having count(*) > 1)order by city;