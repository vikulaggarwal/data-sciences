-- Steps performed for this assignment
-- Imported the data files using Table Data Import Wizard
-- Used the following queries to change the data type of the Date column from text to date

/*
UPDATE bajaj_auto SET Date = STR_TO_DATE(Date, '%d-%M-%Y');
alter table bajaj_auto modify Date date;

UPDATE eicher_motors SET Date = STR_TO_DATE(Date, '%d-%M-%Y');
alter table eicher_motors modify Date date;

UPDATE hero_motocorp SET Date = STR_TO_DATE(Date, '%d-%M-%Y');
alter table hero_motocorp modify Date date;

UPDATE infosys SET Date = STR_TO_DATE(Date, '%d-%M-%Y');
alter table infosys modify Date date;

UPDATE tcs SET Date = STR_TO_DATE(Date, '%d-%M-%Y');
alter table tcs modify Date date;

UPDATE tvs_motors SET Date = STR_TO_DATE(Date, '%d-%M-%Y');
alter table tvs_motors modify Date date;
*/

-- Part 1

-- Creating bajaj1 table with date, close price, 20 day moving average close price and 50 day moving average close price.
drop table if exists bajaj1;
create table bajaj1 as (SELECT date as Date, 
									`Close Price`,
									avg(`Close Price`) over (order by date rows 19 preceding) as `20 Day MA`,
									avg(`Close Price`) over (order by date rows 49 preceding) as `50 Day MA` 
									from bajaj_auto);

-- Creating bajaj1 table with date, close price, 20 day moving average close price and 50 day moving average close price.
drop table if exists eicher1;
create table eicher1 as (select date as Date, 
									 `Close Price`, 
                                     avg(`Close Price`) over (order by date rows 19 preceding) as `20 Day MA`,
									 avg(`Close Price`) over (order by date rows 49 preceding) as `50 Day MA` 
                                     from eicher_motors);

-- Creating bajaj1 table with date, close price, 20 day moving average close price and 50 day moving average close price.
drop table if exists hero1;
create table hero1 as (select date as Date, 
								   `Close Price`, 
								   avg(`Close Price`) over (order by date rows 19 preceding) as `20 Day MA`,
								   avg(`Close Price`) over (order by date rows 49 preceding) as `50 Day MA` 
                                   from hero_motocorp);

-- Creating bajaj1 table with date, close price, 20 day moving average close price and 50 day moving average close price.
drop table if exists infosys1;
create table infosys1 as (select date as Date, 
									  `Close Price`, 
                                      avg(`Close Price`) over (order by date rows 19 preceding) as `20 Day MA`,
									  avg(`Close Price`) over (order by date rows 49 preceding) as `50 Day MA` 
                                      from infosys);

-- Creating bajaj1 table with date, close price, 20 day moving average close price and 50 day moving average close price.
drop table if exists tcs1;
create table tcs1 (select date as Date, 
							   `Close Price`,
							   avg(`Close Price`) over (order by date rows 19 preceding) as `20 Day MA`,
							   avg(`Close Price`) over (order by date rows 49 preceding) as `50 Day MA`
                                from tcs);

-- Creating bajaj1 table with date, close price, 20 day moving average close price and 50 day moving average close price.
drop table if exists tvs1;
create table tvs1 as (select date as Date, 
                                  `Close Price`, 
                                  avg(`Close Price`) over (order by date rows 19 preceding) as `20 Day MA`,
								  avg(`Close Price`) over (order by date rows 49 preceding) as `50 Day MA` 
                                  from tvs_motors);
                                  
-- Updating the first 19 rows for '20 Day MA' and 49 rows for '50 Day MA' to null for all the 6 tables

update bajaj1 set `20 Day MA` = null limit 19;
update bajaj1 set `50 Day MA` = null limit 49;
update eicher1 set `20 Day MA` = null limit 19;
update eicher1 set `50 Day MA` = null limit 49;
update hero1 set `20 Day MA` = null limit 19;
update hero1 set `50 Day MA` = null limit 49;
update infosys1 set `20 Day MA` = null limit 19;
update infosys1 set `50 Day MA` = null limit 49;
update tcs1 set `20 Day MA` = null limit 19;
update tcs1 set `50 Day MA` = null limit 49;
update tvs1 set `20 Day MA` = null limit 19;
update tvs1 set `50 Day MA` = null limit 49;

-- Creating Indexes on the tables created above so that the below queries which use join are optimised.
create index bajaj1_date_idx on bajaj1(Date);
create index eicher1_date_idx on eicher1(Date);
create index hero1_date_idx on hero1(Date);
create index infosys1_date_idx on infosys1(Date);
create index tcs1_date_idx on tcs1(Date);
create index tvs1_date_idx on tvs1(Date);

-- Table for Bajaj 20 day and 50 day averages
select * from bajaj1;

-- Table for Eicher Motors 20 day and 50 day averages
select * from eicher1;

-- Table for Hero Motocorp 20 day and 50 day averages
select * from hero1;

-- Table for Infosys 20 day and 50 day averages
select * from infosys1;

-- Table for TCS 20 day and 50 day averages
select * from tcs1;

-- Table for TVS Motors 20 day and 50 day averages
select * from tvs1;

-- Part 2

-- Master table containing Date and close price for all the 6 stocks
drop table if exists master_stock_table;
create table master_stock_table as    
select a.date as Date, 
	   a.`Close Price` as Bajaj,
       b.`Close Price` as TCS,
       c.`Close Price` as TVS,
       d.`Close Price` as Infosys,
       e.`Close Price` as Eicher,
       f.`Close Price` as Hero 
       from bajaj1 a 
INNER JOIN tcs1 b on a.date = b.date
INNER JOIN tvs1 c on a.date = c.date
INNER JOIN infosys1 d on a.date = d.date
INNER JOIN eicher1 e on a.date = e.date
INNER JOIN hero1 f on a.date = f.date
order by a.date;

-- Master table for close prices of all the 6 stocks
select * from master_stock_table;

-- Part 3
-- Creating table for Bajaj Auto stock BUY/SELL/HOLD signals
drop table if exists bajaj2;
create table bajaj2 as select a.Date, a.`Close Price`, 
		(case 
			when (prev20 < prev50 and curr20 > curr50) THEN 'BUY'
			when (prev20 > prev50 and curr20 < curr50) THEN 'SELL'
			ELSE 'HOLD' 
		END)
        as Signals
from (select Date, `Close Price`, `20 Day MA` as curr20, LAG(`20 Day MA`) OVER W as prev20, `50 Day MA` as curr50,
             LAG(`50 Day MA`) OVER W as prev50 from bajaj1 WINDOW W as (order by Date)) a;

-- Creating table for Eicher Motors stock BUY/SELL/HOLD signals
drop table if exists eicher2;             
create table eicher2 as select Date, `Close Price`, 
		(case 
			when (prev20 < prev50 and curr20 > curr50) THEN 'BUY'
			when (prev20 > prev50 and curr20 < curr50) THEN 'SELL'
			ELSE 'HOLD' 
		END)
        as Signals
from (select Date, `Close Price`, `20 Day MA` as curr20, LAG(`20 Day MA`) OVER W as prev20, `50 Day MA` as curr50,
             LAG(`50 Day MA`) OVER W as prev50 from eicher1 WINDOW W as (order by Date)) a;

-- Creating table for Hero MotoCorp stock BUY/SELL/HOLD signals
drop table if exists hero2;              
create table hero2 as select Date, `Close Price`, 
		(case 
			when (prev20 < prev50 and curr20 > curr50) THEN 'BUY'
			when (prev20 > prev50 and curr20 < curr50) THEN 'SELL'
			ELSE 'HOLD' 
		END)
        as Signals
from (select Date, `Close Price`, `20 Day MA` as curr20, LAG(`20 Day MA`) OVER W as prev20, `50 Day MA` as curr50,
             LAG(`50 Day MA`) OVER W as prev50 from hero1 WINDOW W as (order by Date)) a;

-- Creating table for Infosys stock BUY/SELL/HOLD signals
drop table if exists infosys2;              
create table infosys2 as select Date, `Close Price`, 
		(case 
			when (prev20 < prev50 and curr20 > curr50) THEN 'BUY'
			when (prev20 > prev50 and curr20 < curr50) THEN 'SELL'
			ELSE 'HOLD' 
		END)
        as Signals
from (select Date, `Close Price`, `20 Day MA` as curr20, LAG(`20 Day MA`) OVER W as prev20, `50 Day MA` as curr50,
             LAG(`50 Day MA`) OVER W as prev50 from infosys1 WINDOW W as (order by Date)) a;

-- Creating table for TCS stock BUY/SELL/HOLD signals
drop table if exists tcs2;              
create table tcs2 as select Date, `Close Price`, 
		(case 
			when (prev20 < prev50 and curr20 > curr50) THEN 'BUY'
			when (prev20 > prev50 and curr20 < curr50) THEN 'SELL'
			ELSE 'HOLD' 
		END)
        as Signals
from (select Date, `Close Price`, `20 Day MA` as curr20, LAG(`20 Day MA`) OVER W as prev20, `50 Day MA` as curr50,
             LAG(`50 Day MA`) OVER W as prev50 from tcs1 WINDOW W as (order by Date)) a;
             
-- Creating table for TVS Motors stock BUY/SELL/HOLD signals
drop table if exists tvs2; 
create table tvs2 as select Date, `Close Price`, 
		(case 
			when (prev20 < prev50 and curr20 > curr50) THEN 'BUY'
			when (prev20 > prev50 and curr20 < curr50) THEN 'SELL'
			ELSE 'HOLD' 
		END)
        as Signals
from (select Date, `Close Price`, `20 Day MA` as curr20, LAG(`20 Day MA`) OVER W as prev20, `50 Day MA` as curr50,
             LAG(`50 Day MA`) OVER W as prev50 from tvs1 WINDOW W as (order by Date)) a;
             
-- Table for Bajaj Auto stock BUY/SELL/HOLD signals
select * from bajaj2;

-- Table for Eicher Motors stock BUY/SELL/HOLD signals
select * from eicher2;

-- Table for Hero Motocorp stock BUY/SELL/HOLD signals
select * from hero2;

-- Table for Infosys stock BUY/SELL/HOLD signals
select * from infosys2;

-- Table for TCS stock BUY/SELL/HOLD signals
select * from tcs2;

-- Table for TVS Motors stock BUY/SELL/HOLD signals
select * from tvs2;

-- Creating index on table <stock>2 tables so that the query used in below UDF (or similar UDFs) is optimised
create index bajaj2_date_idx on bajaj2(Date);
create index eicher2_date_idx on eicher2(Date);
create index hero2_date_idx on hero2(Date);
create index infosys2_date_idx on infosys2(Date);
create index tcs2_date_idx on tcs2(Date);
create index tvs2_date_idx on tvs2(Date);

-- Part 4
drop function if exists bajaj_stock_signal;
DELIMITER $$

create function bajaj_stock_signal(signal_date date)
	returns varchar(4) deterministic
begin
	declare signal_bajaj varchar(4);
	select signals into signal_bajaj from bajaj2 where Date = signal_date;
	return signal_bajaj;
end
$$

DELIMITER ;

-- Example call to the UDF created above.
select bajaj_stock_signal('2015-08-24');