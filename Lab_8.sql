use SHU_UNIVER

-- TASK 1 --
create view [�������������]
	as select t.TEACHER,
	t.TEACHER_NAME,
	t.GENDER,
	t.PULPIT
	from TEACHER t

select * from [�������������]
drop view [�������������]

-- TASK 2 --
create view [����������_������]
	as select distinct (f.FACULTY_NAME)[���������],
				count(p.FACULTY)[���������� ������]
	from FACULTY f join PULPIT p
	on p.FACULTY = f.FACULTY
	group by f.FACULTY_NAME;

select * from [����������_������]
drop view [����������_������]

-- TASK 3 --
create view [���������]
	as select a.AUDITORIUM, a.AUDITORIUM_NAME
	from AUDITORIUM a
	where a.AUDITORIUM_TYPE like '��'

select * from [���������]

INSERT  [���������]
	VALUES('340-6', '340-1');

SELECT * FROM AUDITORIUM;

drop view [���������]

-- TASK 4 --
create view [����������_���������]
	as select a.AUDITORIUM, a.AUDITORIUM_NAME
	from AUDITORIUM a
	where a.AUDITORIUM_TYPE like '��'
	with check option

select * from [����������_���������]

INSERT [����������_���������]
	VALUES('241-1', '241-1', '��-�');

drop view [����������_���������]


-- TASK 5 --
create view [����������]
	as select top 150 s.SUBJECT, s.SUBJECT_NAME, s.PULPIT
	from SUBJECT s
	order by s.SUBJECT_NAME

select * from [����������]

-- TASK 6 --

alter view [����������_������] with schemabinding
	as select distinct (f.FACULTY_NAME)[���������],
				count(p.FACULTY)[���������� ������]
	from dbo.FACULTY f JOIN dbo.PULPIT p
	on p.FACULTY = f.FACULTY
	group by f.FACULTY_NAME;

drop view [����������_������]


-- TASK 8


create view [����������]
	as select top(20) 
	(
		case
			when DAY_OF_WEEK=1 then '�����������'
			when DAY_OF_WEEK=2 then '�������'
			when DAY_OF_WEEK=3 then '�����'
			when DAY_OF_WEEK=4 then '�������'
			when DAY_OF_WEEK=5 then '�������'
			when DAY_OF_WEEK=6 then '�������'
			when DAY_OF_WEEK=7 then '�����������'
			else '��������'
		end
	)[Day],
LESSON_TIME, TEACHER, 
AUDITORIUM,
[1],[2],[3],[4],[5],[6],[7],[8],[9],[19]
from TIMETABLE  PIVOT (max(SUBJ) for GROUP_NAME in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[19])) AS test_pivot
order by DAY_OF_WEEK asc

select * from ����������
drop view ����������