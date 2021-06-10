use SHU_MYBASE2

select e.GENDER, count(*)[count]
	from EMPLOYEES e
	group by e.GENDER
	having e.GENDER = 'ì'
	union
select e.GENDER, count(*)[count]
	from EMPLOYEES e
	group by e.GENDER
	having e.GENDER = 'æ'

select e.GENDER, count(*)[count]
	from EMPLOYEES e
	group by rollup(e.GENDER)

select e.GENDER, count(*)[count]
	from EMPLOYEES e
	group by cube(e.GENDER, e.BIRTHDAY)