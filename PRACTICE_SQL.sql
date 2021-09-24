-- PDF Page No.: 2, Ques. No.: 2 (Found a problem. Temporarily incomplete!)
    -- player table
    create table player(
        pid varchar2(3),
        pname varchar2(10),
        nationality varchar2(10),
        position varchar2(10),
        age number(3),
        primary key(pid)
    );

    insert into player values('e01', 'samuel', 'english', 'defender', 21);
    insert into player values('e02', 'dsilva', 'brazilian', 'defender', 20);
    insert into player values('e03', 'martinez', 'italian', 'attacker', 22);
    insert into player values('e04', 'jordan', 'english', 'midfielder', 19);
    insert into player values('e05', 'michael', 'english', 'defender', 20);
    insert into player values('e06', 'miguel', 'italian', 'attacker', 25);
    insert into player values('e07', 'carlos', 'brazilian', 'defender', 17);

    -- club table
    create table club(
        cid varchar2(3),
        cname varchar2(10),
        country varchar2(10),
        tier number(1),
        primary key(cid)
    );

    insert into club values('c01', 'chelsea', 'england', 1);
    insert into club values('c02', 'liverpool', 'england', 3);
    insert into club values('c03', 'juventus', 'italy', 1);
    insert into club values('c04', 'milan', 'italy', 2);

    -- match table
    create table match(
        pid varchar2(3),
        cid varchar2(3),
        goal_scored number(1),
        no_of_assists number(2),
        no_of_fouls number(2),
        foreign key(pid) references player(pid) on delete cascade,
        foreign key(cid) references club(cid) on delete cascade
    );

-- PDF Page No.: 4, Ques No.: 5
    -- detective table
    create table detective(
        detid varchar2(3),
        dname varchar2(10),
        sex VARCHAR2(1),
        age number(2),
        experience number(2),
        primary key(detid)
    );

    insert into detective values('d01', 'Suhasini', 'f', 25, 7);
    insert into detective values('d02', 'Gauri', 'f', 28, 10);
    insert into detective values('d03', 'Sam', 'm', 23, 8);
    insert into detective values('d04', 'Rameswar', 'm', 30, 12);
    insert into detective values('d05', 'Sunanda', 'f', 25, 10);
    insert into detective values('d06', 'Nikhil', 'm', 20, 2);

    -- crime table
    create table crime(
        cid varchar2(3),
        cdate date,
        location varchar2(15),
        type varchar2(10),
        primary key(cid)
    );
    insert into crime values('c01', '15-jan-2010', 'kolkata', 'robbery');
    insert into crime values('c02', '7-jul-2015', 'north 24 pgns', 'homicide');
    insert into crime values('c03', '12-feb-2008', 'purulia', 'fraud');
    insert into crime values('c04', '20-mar-2016', 'north 24 pgns', 'robbery');
    insert into crime values('c05', '22-dec-2017', 'north 24 pgns', 'robbery');
    insert into crime values('c06', '2-aug-2015', 'kolkata', 'fraud');
    insert into crime values('c07', '23-sep-2013', 'kolkata', 'homicide');
    insert into crime values('c08', '25-sep-2013', 'kolkata', 'homicide');

    -- investigates table
    create table investigates(
        detid varchar2(3),
        cid varchar2(3),
        date_from date,
        date_to date,
        status varchar2(10)
        foreign key(detid) references detective(detid),
        foreign key(cid) references crime(cid)
    );
    insert into investigates values('d01', 'c02', '7-jul-2015', '12-sep-2015', 'solved');
    insert into investigates values('d02', 'c07', '30-sep-2013', '2-nov-2013', 'solved');
    insert into investigates values('d05', 'c08', '25-sep-2013', '12-dec-2013', 'unsolved');
    insert into investigates values('d06', 'c05', '22-dec-2017', '10-jan-2018', 'unknown');

    select * from detective;
    select * from crime;
    select * from investigates;

    -- Query1: Give details of all female detectives below age 35 who has solved homicide cases

        -- (Using bridge)
        select d.* from detective d, investigates i, crime c
        where
            d.detid = i.detid and
            c.cid = i.cid and
            d.sex = 'f' and
            d.age < 35 and
            c.type = 'homicide' and
            i.status = 'solved';

        -- (Using scalar subquery)
        select * from detective
        where
            sex = 'f' and
            age < 35 and
            detid in(
                select detid from investigates
                where
                    cid in(
                        select cid from crime
                        where
                            type = 'homicide'
                    ) and
                    status = 'solved'
            );

        -- (Using correlated subquery)
        select d.* from detective d
        where exists(
            select i.* from investigates i
            where exists(
                select * from crime c
                where
                    d.detid = i.detid and
                    c.cid = i.cid and
                    d.sex = 'f' and
                    d.age < 35 and
                    c.type = 'homicide' and
                    i.status = 'solved'
            )
        );

    -- Query2: Find the location where maximum number of crimes have been committed

        -- (Using scalar subquery)
		select location, count(*) as "No of crimes" from crime
		group by location
		having count(*) in(
			select max(count(*)) as "No. Of Crimes" from crime
			group by location
		);
	-- Ouery3: List all robbery cases that have been taken place during the year 2016 and 2017 at "North 24 pgns"
		
		-- (Using only aggregate function)
		select * from crime
		where
			location = 'north 24 pgns' and
			type = 'robbery' and
			cdate between '1-jan2016' and '31-dec-2017';
			
-- PDF Page No.: 5, Ques No.: 6
	-- salesperson table
	create table salesperson(
		sid varchar2(3),
		sname varchar2(10),
		age number(2),
		city varchar2(10),
		primary key(sid)
	);
	
	insert into salesperson values('s01', 'Ramesh', 22, 'kolkata');
	insert into salesperson values('s02', 'Ram', 29, 'kolkata');
	insert into salesperson values('s03', 'Dip', 19, 'kolkata');
	insert into salesperson values('s04', 'Kailash', 22, 'bangalore');
	insert into salesperson values('s05', 'Dipak', 20, 'delhi');
	insert into salesperson values('s06', 'Nitin', 22, 'delhi');
	insert into salesperson values('s07', 'Mukesh', 20, 'kolkata');
	insert into salesperson values('s08', 'Ramakanto', 26, 'kolkata');
	
	-- product table
	create table product(
		pid varchar2(3),
		pname varchar2(15),
		company varchar2(10),
		price number(5),
		color varchar2(10),
		type varchar2(15),
		primary key(pid)
	);
	
	insert into product values('p01', 'air conditioner', 'lloyd', 9900, 'white', 'electronic');
	insert into product values('p02', 'air conditioner', 'samsung', 8900, 'grey', 'electronic');
	insert into product values('p03', 'smartphone', 'samsung', 22000, 'white', 'electronic');
	insert into product values('p04', 'smartphone', 'samsung', 23700, 'black', 'electronic');
	insert into product values('p05', 'smartphone', 'realme', 25500, 'black', 'electronic');
	insert into product values('p06', 'smartphone', 'redmi', 19999, 'black', 'electronic');
	insert into product values('p07', 'table', 'indigo', 6700, 'wooden', 'furniture');
	insert into product values('p08', 'bed', 'indigo', 9800, 'wooden', 'furniture');
	
	-- sales table
	create table sales(
		sid varchar2(3),
		pid varchar2(3),
		sales_date date,
		quantity number(3),
		foreign key(sid) references salesperson(sid) on delete cascade,
		foreign key(pid) references product(pid) on delete cascade
	);
	
	insert into sales values('s01', 'p08', '01-sep-2017', 2);
	insert into sales values('s01', 'p07', '01-sep-2017', 2);
	insert into sales values('s03', 'p07', '22-sep-2017', 3);
	insert into sales values('s03', 'p08', '22-sep-2017', 1);
	insert into sales values('s04', 'p03', '12-aug-2017', 3);
	insert into sales values('s04', 'p05', '12-aug-2017', 5);
	insert into sales values('s04', 'p06', '10-sep-2017', 4);
	insert into sales values('s04', 'p03', '12-aug-2017', 3);
	insert into sales values('s08', 'p05', '12-sep-2017', 2);
	insert into sales values('s07', 'p06', '16-sep-2017', 3);
	insert into sales values('s02', 'p01', '12-mar-2017', 2);
	insert into sales values('s05', 'p02', '12-apr-2017', 1);
	insert into sales values('s06', 'p01', '14-may-2017', 2);
	insert into sales values('s02', 'p02', '12-mar-2017', 2);
	insert into sales values('s06', 'p01', '02-apr-2018', 2);
	insert into sales values('s02', 'p02', '04-may-2018', 3);
	
	-- Query1: Find all salesperson from kolkata who have sold electronic goods during sept, 2017
		-- (Using scalar subquery)
		select * from salesperson
		where
		sid in(
			select sid from sales
			where
			pid in(
				select pid from product
				where
					type = 'electronic'
			) and
			sales_date between '01-sep-2017' and '30-sep-2017'
		) and
		city = 'kolkata';
		
		-- (Using correlated subquery)
		select s.* from salesperson s
		where exists(
			select sl.* from sales sl
			where exists(
				select p.* from product p
				where
					s.sid = sl.sid and
					p.pid = sl.pid and
					s.city = 'kolkata' and
					p.type = 'electronic' and
					sales_date between '01-sep-2017' and '30-sep-2017'
			)
		);
	
	-- Query2: List all black colored smartphones priced above rs. 20000
		select * from product
		where
			pname = 'smartphone' and
			color = 'black' and
			price > 20000;
	
	-- Query3: Find the air conditioner company which has seen the highest sales in the year 2017
		
		with tempTable as (
			select s.pid, sum(s.quantity) as "Total sold" from sales s, product p
			where
				p.pid = s.pid and
				s.sales_date between '01-jan-17' and '31-dec-17' and
				p.pname = 'air conditioner'
			group by s.pid
		)
		select p.company from product p, tempTable t
		where
			p.pid = t.pid and
			t."Total sold" = (
				select max(tempTable."Total sold") from tempTable
			);

-- PDF Page No.: 8, Ques No.: 2
	-- cab table
	create table cab(
		cno number(2),
		model varchar2(15),
		color varchar2(10),
		purchase_date date,
		primary key(cno)
	);
	
	insert into cab values(1, 'Tata Hexa', 'black', '12-aug-2010');
	insert into cab values(2, 'Audi R8', 'red', '29-nov-2008');
	insert into cab values(3, 'Ford Eco Sport', 'white', '12-jul-2009');
	insert into cab values(4, 'Audi A5', 'white', '2-may-2010');
	
	-- driver table
	create table driver(
		did number(2),
		dname varchar2(10),
		phone number(10),
		rating number(1),
		age number(2),
		primary key(did)
	);
	
	insert into driver values(1, 'Ramesh', 1234567890, 3, 26);
	insert into driver values(2, 'Suresh', 1234567890, 4, 25);
	insert into driver values(3, 'Vim', 1234567890, 4, 22);
	insert into driver values(4, 'Nayek', 1234567890, 5, 27);
	insert into driver values(5, 'Samrat', 1234567890, 5, 25);
	insert into driver values(6, 'Guru', 1234567890, 5, 22);
	
	-- allotted table
	create table allotted(
		cno number(2),
		did number(2),
		"date" date,
		foreign key(cno) references cab(cno) on delete cascade,
		foreign key(did) references driver(did) on delete cascade
	);
	
	insert into allotted values(2, 1, '02-jul-2018');
	insert into allotted values(4, 3, '12-jan-2018');
	insert into allotted values(1, 2, '15-sep-2018');
	insert into allotted values(4, 5, '02-jan-2018');
	insert into allotted values(4, 6, '12-may-2018');
	insert into allotted values(3, 4, '12-feb-2020');
	insert into allotted values(1, 5, '12-dec-2020');
	insert into allotted values(2, 3, '24-sep-2021');
	insert into allotted values(4, 6, '24-sep-2021');
	insert into allotted values(1, 1, '24-sep-2021');
	
	-- Query1: Find average age of all drivers who have driven Audi A5
	-- TO BE NOTED: The use of to_date(). Dates cannot be compared only using '=' or '<>'.
		-- (Using scalar subquery)
		select avg(age) from driver
		where
			did in(
				select did from allotted
				where
					cno in(
						select cno from cab
						where
							model = 'Audi A5'
					) and
					"date" <> to_date((select sysdate from dual))
				group by
					cno, did
			);
		-- (Using bridge / join)
		select avg(distinct(mixed.age)) as "Avg. age" from
		(
			select d.age from driver d, allotted a, cab c
			where
				d.did = a.did and
				c.cno = a.cno and
				c.model = 'Audi A5' and
				a."date" <> to_date((select sysdate from dual))
		) mixed;
			
	-- Query2: Display details of all cabs which have been driven by the driver with highest rating in january, 2018
		-- (Using scalar subquery)
		select * from cab
		where
			cno in(
				select cno from allotted
				where
					did in(
						select did from driver
						where
							rating in(select max(rating) from driver)
					) and
					"date" between '01-jan-2018' and '31-jan-2018'
			);
		-- (Using bridge / join)
		select c.* from cab c, allotted a, driver d
		where
			c.cno = a.cno and
			d.did = a.did and
			d.rating in(
				select max(rating) from driver
			) and
			a."date" between '01-jan-2018' and '31-jan-2018';
			
		-- (Using correlated subquery)
		select c.* from cab c
		where exists(
			select * from allotted a
			where exists(
				select * from driver d
				where
					a.cno = c.cno and
					a.did = d.did and
					d.rating = (
						select max(rating) from driver
					) and
					a."date" between '01-jan-18' and '31-jan-18'
			)
		);
		
	-- Query3: Delete all allotments scheduled today
		delete from allotted
		where
			"date" = to_date((select sysdate from dual));