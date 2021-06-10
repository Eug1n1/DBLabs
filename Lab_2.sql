create database SHUMSKIY_UNIVER

use SHUMSKIY_UNIVER
create table STUDENT(
	Номер_зачетки int not null,
	Фамилия_студента nvarchar(20),
	Номер_группы int
);


use SHUMSKIY_UNIVER
alter table STUDENT add Дата_зачисления date not null;

use SHUMSKIY_UNIVER
alter table STUDENT drop column Дата_зачисления;

use SHUMSKIY_UNIVER
alter table STUDENT add primary key (Номер_зачетки);

use SHUMSKIY_UNIVER
INSERT INTO STUDENT VALUES	
						(112311145, 'Шумский', 5),
						(987656721, 'Петров', 6),
						(234567811, 'Сидоров', 2),
						(698765444, 'Иванов', 1)


select * from STUDENT;

select Номер_группы, Фамилия_студента from STUDENT;

select count(*) from STUDENT;


select Номер_зачетки[lol] from STUDENT where Номер_зачетки > 234567811;

select top(2) Номер_зачетки, Фамилия_студента from STUDENT order by Номер_зачетки desc;


update STUDENT set Номер_группы = 5;

delete from STUDENT where Номер_зачетки = 987656721;
select * from STUDENT;

select * from STUDENT where Номер_зачетки between 112311145 and 698765444;
select * from STUDENT where Фамилия_студента like 'Ш%'
select * from STUDENT where Фамилия_студента in ('Петров', 'Иванов')

drop table STUDENT;



create table RESULTS(
	ID int primary key identity(1,1),
	Student_name nvarchar(20),
	Math int not null,
	OOP int not null,
	OAIP int not null,
	Java int not null,
	KSIS int not null,
	Aver_value as (Math+OOP+OAIP+Java+KSIS) / 5.0
);


insert into RESULTS values 
				('Zalobi', 6, 7, 5, 4, 7),
				('Azila', 4, 5, 6, 7, 8),
				('Ola', 7, 6, 4, 7, 5)

select * from RESULTS

drop table RESULTS;

create table STUDENT (
	Номер_зачетки int primary key,
	ФИО nvarchar(50) not null,
	Дата_рождения date not null,
	Пол nchar(1) check (Пол in ('м', 'ж')) not null,
	Дата_поступления date not null
);

insert into STUDENT values
				(123432, 'zibab', '2000-01-12', 'ж', '2020-08-30'),
				(987612, 'zibob', '2002-06-05', 'ж', '2020-08-30'),
				(987654, 'kilalol', '2001-10-01', 'м', '2020-08-30'),
				(456787, 'gagi', '2003-06-06', 'ж', '2020-08-30'),
				(987891, 'lalito', '2003-12-10', 'ж', '2020-08-30'),
				(123456, 'fabolo', '2000-03-09', 'ж', '2020-08-30'),
				(567876, 'logoza', '2001-08-05', 'м', '2020-08-30')

select * from STUDENT 
	where Пол = 'ж' 
	and 
	year(Дата_поступления) - year(Дата_рождения) >= 18;

drop table STUDENT;
drop table RESULTS;