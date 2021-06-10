use SHU_UNIVER

-- TASK 1 --
create view [Преподаватель]
	as select t.TEACHER,
	t.TEACHER_NAME,
	t.GENDER,
	t.PULPIT
	from TEACHER t

select * from [Преподаватель]
drop view [Преподаватель]

-- TASK 2 --
create view [Количество_кафедр]
	as select distinct (f.FACULTY_NAME)[Факультет],
				count(p.FACULTY)[Количество кафедр]
	from FACULTY f join PULPIT p
	on p.FACULTY = f.FACULTY
	group by f.FACULTY_NAME;

select * from [Количество_кафедр]
drop view [Количество_кафедр]

-- TASK 3 --
create view [Аудитории]
	as select a.AUDITORIUM, a.AUDITORIUM_NAME
	from AUDITORIUM a
	where a.AUDITORIUM_TYPE like 'ЛК'

select * from [Аудитории]

INSERT  [Аудитории]
	VALUES('340-6', '340-1');

SELECT * FROM AUDITORIUM;

drop view [Аудитории]

-- TASK 4 --
create view [Лекционные_аудитории]
	as select a.AUDITORIUM, a.AUDITORIUM_NAME
	from AUDITORIUM a
	where a.AUDITORIUM_TYPE like 'ЛК'
	with check option

select * from [Лекционные_аудитории]

INSERT [Лекционные_аудитории]
	VALUES('241-1', '241-1', 'ЛБ-К');

drop view [Лекционные_аудитории]


-- TASK 5 --
create view [Дисциплины]
	as select top 150 s.SUBJECT, s.SUBJECT_NAME, s.PULPIT
	from SUBJECT s
	order by s.SUBJECT_NAME

select * from [Дисциплины]

-- TASK 6 --

alter view [Количество_кафедр] with schemabinding
	as select distinct (f.FACULTY_NAME)[Факультет],
				count(p.FACULTY)[Количество кафедр]
	from dbo.FACULTY f JOIN dbo.PULPIT p
	on p.FACULTY = f.FACULTY
	group by f.FACULTY_NAME;

drop view [Количество_кафедр]


-- TASK 8


create view [расписание]
	as select top(20) 
	(
		case
			when DAY_OF_WEEK=1 then 'Понедельник'
			when DAY_OF_WEEK=2 then 'Вторник'
			when DAY_OF_WEEK=3 then 'Среда'
			when DAY_OF_WEEK=4 then 'Четверг'
			when DAY_OF_WEEK=5 then 'Пятница'
			when DAY_OF_WEEK=6 then 'Суббота'
			when DAY_OF_WEEK=7 then 'Воскресенье'
			else 'Ошибочка'
		end
	)[Day],
LESSON_TIME, TEACHER, 
AUDITORIUM,
[1],[2],[3],[4],[5],[6],[7],[8],[9],[19]
from TIMETABLE  PIVOT (max(SUBJ) for GROUP_NAME in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[19])) AS test_pivot
order by DAY_OF_WEEK asc

select * from расписание
drop view расписание