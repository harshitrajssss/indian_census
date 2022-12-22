select * from project.dbo.data1;
select * from project.dbo.data2;
  
---number of rows into our dataset
select count(*) from project.dbo.data1
select count(*) from project.dbo.data2

----need to calculate dataset for jharkhand and bihar

select * from project.dbo.data1 where state in ('Jharkhand','Bihar')

----total population

select sum(population) as Population from project..data2
select avg(growth)*100 as avg_growth from project..data1
select State,round(avg(growth)*100,0) as avg_growth from project..data1 group by state;
select State,round(avg(growth)*100,0) as avg_growth from project..data1 group by state order by avg_growth desc;
select State,round(avg(growth)*100,0) as avg_growth from project..data1 group by state  having round(avg(growth)*100,0)>30 order by avg_growth desc;

---where clause is used to filter rows thing where as having clause is used onto the aggregated rows


---- top 3 states showing highest avg growth
select top 3 State,round(avg(growth)*100,0) as avg_growth from project..data1 group by state order by avg_growth desc;

select top 3 State,round(avg(growth)*100,0) as avg_growth from project..data1 group by state order by avg_growth asc ;
  
----top and bottom state in a single table


drop table if exists #topstates   ----- there will be error if we dont include this "There is already an object named '#topstates' in the database.

create table #topstates
( state nvarchar(255),
  topstates float

  )

insert into #topstates
select top 3 State,round(avg(growth)*100,0) as avg_growth from project..data1 group by state order by avg_growth desc ;
select * from #topstates



drop table if exists #bottomstates   ----- there will be error if we dont include this "There is already an object named '#topstates' in the database.

create table #bottomstates
( state nvarchar(255),
  bottomstates float

  )

insert into #bottomstates
select top 3 State,round(avg(growth)*100,0) as avg_growth from project..data1 group by state order by avg_growth asc ;
select * from #bottomstates



select * from #topstates
union
select * from #bottomstates



------filter data of state which starts with  A

select distinct state,population as pp from project..data2 where state like 'A%' and Population>30000
select distinct state from project..data2 where state like 'A%' OR state like '%M'

---- now i need to find no. of males and females 
--- joing both table with district as commmon
select a.district,a.state,a.[sex-ratio]/1000 as sex_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district

---(1)- sex-ratio= females\males  (2)- females+males=population     using two equation 
--- males= population\(sex_ratio+1)
select c.district,c.state,round(c.population/(c.[sex_ratio]+1),0) as males from
(select a.district,a.state,a.[sex-ratio]/1000 as sex_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district)c

---- total number males group by state
select d.state,sum(d.males) as total_males from
(select c.district,c.state,round(c.population/(c.[sex_ratio]+1),0) as males from
(select a.district,a.state,a.[sex-ratio]/1000 as sex_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district)c)d group by state;

 -- number of litrate people

select d.state,sum(d.no_literate) as total_literate from
(select c.district,c.state,round(((c.literacy)*population/100),0) as no_literate from
(select a.district,a.state,a.literacy as literacy,b.population from project..data1 a inner join project..data2 b on a.district=b.district)c)d group by d.state



