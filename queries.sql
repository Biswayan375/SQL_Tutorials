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
insert into employee values('E01', 'Ajay', 3000, 'Kolkata', '12-JAN-00');
insert into employee values('E02', 'Bijay', 3219, 'Gurgaon', '01-JUL-10');
insert into employee values('E03', 'Roy', 5270, 'Kolkata', '18-FEB-12');
insert into employee values('E04', 'Ram', 4350, 'UP', '12-JAN-02');
insert into employee values('E05', 'Sam', 4100, 'Mumbai', '18-MAY-07');
insert into employee values('E06', 'Sunil', 4517, 'Gujrat', '16-JUN-1999');
insert into employee values('E07', 'Sunil', 4300, 'Kolkata', '12-AUG-2001');

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
	
-- To create work table where e_id is the only primary key of employee table and d_id is the only primary key of department table (The related references are in 4.Primary_Foreign_Bridge_SubQry_Alias_Distinct.txt)
create table work(
	eid varchar2(5),
	did varchar2(5),
	foreign key(eid)references employee(e_id) on delete cascade,
	foreign key(did)references department(d_id) on delete cascade
);

-- Find out the department name where E01 works without using bridge
select name from department
where
	d_id in(
		select did from work
		where
			eid = 'E01'
	);
	
-- Find out the department name where E01 works with bridges
select name from work, department
where
	department.d_id = work.did and
	work.eid = 'E01';

-- Find out name of people who work in HR department
select employee.name from employee, work
where
	work.did = (select d_id from department where name='HR') and
	employee.e_id = work.eid;
	
-- Another way to do the above query
select e.name from employee e, department d, work w
where
	e.e_id = w.eid and
	w.did = d.d_id and
	d.name = 'IT';

-- Doing the same above thing with subqueries
select name from employee
where
	e_id in(select eid from work
		where did = (select d_id from department
			where name = 'IT'
		)
	);

-- Give out the department name of those employees who live in kolkata
select d.name from employee e, department d, work w
where
	d.d_id = w.did and
	w.eid = e.e_id and
	e.city = 'Kolkata';

-- Give out the employee details from kolkata who has assigned with atleast one department
select * from employee
where
	name in(select distinct(e.name) from employee e, work w
	where
		e.e_id = w.eid and
		e.city = 'Kolkata');
		

select e.e_id, e.name, count(*) as "No. of deps. assigned" from employee e, work w
group by w.eid, e.e_id, e.name
having
	w.eid = e.e_id;

-- The following 2 examples demonstrate group by with more than one columns	

-- Give out the name and id of the employee along with the number of departments assigned to them
select e.e_id, e.name, count(*) as "No. of deps. assigned" from employee e, work w where w.eid = e.e_id
group by
	e.e_id, e.name;
	
-- Find the name of the departments along with the no of employees work in that department
select d.name, count(*) from department d, work w
where
	w.did = d.d_id
	group by d.d_id, d.name;