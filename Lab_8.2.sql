use SHU_MYBASE2

create view [male_employees]
	as select e.ID, e.NAME
	from EMPLOYEES e

alter view [male_employees]
	as select e.ID, e.NAME
	from EMPLOYEES e
	where e.GENDER = 'ì'

select * from [male_employees]

create view [enrollment_view]
	as select en.DEPARTMENT, en.POSITION_NAME, em.NAME, em.SURNAME
	from ENROLLMENT en join EMPLOYEES em
	on en.ID = em.ID

select * from [enrollment_view]