create database SHUMSKIY_UNIVER

use SHUMSKIY_UNIVER
create table STUDENT(
	�����_������� int not null,
	�������_�������� nvarchar(20),
	�����_������ int
);


use SHUMSKIY_UNIVER
alter table STUDENT add ����_���������� date not null;

use SHUMSKIY_UNIVER
alter table STUDENT drop column ����_����������;

use SHUMSKIY_UNIVER
alter table STUDENT add primary key (�����_�������);

use SHUMSKIY_UNIVER
INSERT INTO STUDENT VALUES	
						(112311145, '�������', 5),
						(987656721, '������', 6),
						(234567811, '�������', 2),
						(698765444, '������', 1)


select * from STUDENT;

select �����_������, �������_�������� from STUDENT;

select count(*) from STUDENT;


select �����_�������[lol] from STUDENT where �����_������� > 234567811;

select top(2) �����_�������, �������_�������� from STUDENT order by �����_������� desc;


update STUDENT set �����_������ = 5;

delete from STUDENT where �����_������� = 987656721;
select * from STUDENT;

select * from STUDENT where �����_������� between 112311145 and 698765444;
select * from STUDENT where �������_�������� like '�%'
select * from STUDENT where �������_�������� in ('������', '������')

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
	�����_������� int primary key,
	��� nvarchar(50) not null,
	����_�������� date not null,
	��� nchar(1) check (��� in ('�', '�')) not null,
	����_����������� date not null
);

insert into STUDENT values
				(123432, 'zibab', '2000-01-12', '�', '2020-08-30'),
				(987612, 'zibob', '2002-06-05', '�', '2020-08-30'),
				(987654, 'kilalol', '2001-10-01', '�', '2020-08-30'),
				(456787, 'gagi', '2003-06-06', '�', '2020-08-30'),
				(987891, 'lalito', '2003-12-10', '�', '2020-08-30'),
				(123456, 'fabolo', '2000-03-09', '�', '2020-08-30'),
				(567876, 'logoza', '2001-08-05', '�', '2020-08-30')

select * from STUDENT 
	where ��� = '�' 
	and 
	year(����_�����������) - year(����_��������) >= 18;

drop table STUDENT;
drop table RESULTS;