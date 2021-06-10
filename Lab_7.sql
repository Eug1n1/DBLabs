use SHU_UNIVER

-- 1 task
select 
	max(AUDITORIUM.AUDITORIUM_CAPACITY)[max],
	min(AUDITORIUM.AUDITORIUM_CAPACITY)[min],
	avg(AUDITORIUM.AUDITORIUM_CAPACITY)[avg],
	count(*)[count]
	from AUDITORIUM;

-- 2 task
select AUDITORIUM.AUDITORIUM_TYPE, 
	max(AUDITORIUM.AUDITORIUM_CAPACITY)[max],
	min(AUDITORIUM.AUDITORIUM_CAPACITY)[min],
	avg(AUDITORIUM.AUDITORIUM_CAPACITY)[avg],
	sum(AUDITORIUM.AUDITORIUM_CAPACITY)[sum],
	count(*)[count]
	from AUDITORIUM join AUDITORIUM_TYPE
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	group by AUDITORIUM.AUDITORIUM_TYPE;

-- 3 task
select *
from (select case
	  when(PROGRESS.NOTE between 4 and 5) then '4-5'
	  when(PROGRESS.NOTE between 6 and 7) then '6-7'
	  when(PROGRESS.NOTE between 8 and 9) then '8-9'
	  else '10'
	  end[ÓˆÂÌÍË], count(*)[count]
	  from PROGRESS
	  group by case
	  when(PROGRESS.NOTE between 4 and 5) then '4-5'
	  when(PROGRESS.NOTE between 6 and 7) then '6-7'
	  when(PROGRESS.NOTE between 8 and 9) then '8-9'
	  else '10'
	  end) as t
		order by case
			when t.ÓˆÂÌÍË = '4-5' then 4
			when t.ÓˆÂÌÍË = '6-7' then 3
			when t.ÓˆÂÌÍË = '8-9' then 2
			else 1
		end

-- TASK 4 --
select f.FACULTY, 
	g.PROFESSION, 
	YEAR(GETDATE()) - g.YEAR_FIRST[course], 
	round(avg(cast(p.NOTE as float)),2)[average_note]
from FACULTY f join GROUPS g
on f.FACULTY = g.FACULTY
join STUDENT s
on g.IDGROUP = s.IDGROUP
join PROGRESS p
on s.IDSTUDENT = p.IDSTUDENT
group by f.FACULTY,
		g.PROFESSION,
		g.YEAR_FIRST
order by average_note desc


select f.FACULTY, 
	g.PROFESSION, 
	YEAR(GETDATE()) - g.YEAR_FIRST[course], 
	round(avg(cast(p.NOTE as float)),2)[average_note]
from FACULTY f join GROUPS g
on f.FACULTY = g.FACULTY
join STUDENT s
on g.IDGROUP = s.IDGROUP
join PROGRESS p
on s.IDSTUDENT = p.IDSTUDENT
where p.SUBJECT = '¡ƒ' or p.SUBJECT = 'Œ¿Ëœ'
group by f.FACULTY,
		g.PROFESSION,
		g.YEAR_FIRST
order by average_note desc


-- TASK 5 --

select g.PROFESSION, p.SUBJECT, round(avg(cast(p.Note as float)), 2)[average_note]
	from FACULTY f join GROUPS g
	on f.FACULTY = g.FACULTY
	join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where f.FACULTY = '“Œ¬'
	group by rollup(g.FACULTY, g.PROFESSION, p.SUBJECT);

-- TASK 6 --

select g.PROFESSION, p.SUBJECT, round(avg(cast(p.Note as float)), 2)[average_note]
	from FACULTY f join GROUPS g
	on f.FACULTY = g.FACULTY
	join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where f.FACULTY = '“Œ¬'
	group by cube(g.FACULTY, g.PROFESSION, p.SUBJECT);


-- TASK 7 --

select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '“Œ¬'
	group by g.PROFESSION,
			p.SUBJECT
	union
select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '’“Ë“'
	group by g.PROFESSION,
			p.SUBJECT

select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '“Œ¬'
	group by g.PROFESSION,
			p.SUBJECT
	union all
select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '’“Ë“'
	group by g.PROFESSION,
			p.SUBJECT

-- TASK 8 --
select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '“Œ¬'
	group by g.PROFESSION,
			p.SUBJECT
	intersect
select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '’“Ë“'
	group by g.PROFESSION,
			p.SUBJECT;

-- TASK 9 --
select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '“Œ¬'
	group by g.PROFESSION,
			p.SUBJECT
	except
select g.PROFESSION, p.SUBJECT, ROUND(avg(cast(p.NOTE as float)), 2)[average]
	from GROUPS g join STUDENT s
	on g.IDGROUP = s.IDGROUP
	join PROGRESS p
	on s.IDSTUDENT = p.IDSTUDENT
	where g.FACULTY = '’“Ë“'
	group by g.PROFESSION,
			p.SUBJECT	

-- TASK 10 --

select p.SUBJECT, count(*)[count]
	from PROGRESS p
	group by p.SUBJECT,
			p.NOTE
	having p.NOTE between 8 and 9
	order by [count]