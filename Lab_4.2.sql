use master 
go
create database SHU_MYBASE2
on primary
( 
	name = N'SHU_MYBASE_mdf', 
	filename = N'C:\Projs\DB\SHU_MYBASE.mdf',
	size = 5Mb, 
	maxsize=10Mb, 
	filegrowth=1Mb
),
( 
	name = N'SHU_MYBASE_ndf', 
	filename = N'C:\Projs\DB\SHU_MYBASE.ndf',
	size = 5Mb, 
	maxsize=10Mb, 
	filegrowth=10%
),
filegroup G1
( 
	name = N'SHU_MYBASE11_ndf_ndf', 
	filename = N'C:\Projs\DB\SHU_MYBASE11.ndf',
	size = 10Mb, 
	maxsize=15Mb, 
	filegrowth=1Mb
),
( 
	name = N'SHU_MYBASE12_ndf', 
	filename = N'C:\Projs\DB\SHU_MYBASE12.ndf',
	size = 2Mb,
	maxsize=5Mb,
	filegrowth=1Mb
),
filegroup G2
(
	name = N'SHU_MYBASE21_ndf',
	filename = N'C:\Projs\DB\SHU_MYBASE21.ndf',
	size = 5Mb,
	maxsize = 10Mb,
	filegrowth = 1Mb
),
(
	name = N'SHU_MYBASE22_ndf',
	filename = N'C:\Projs\DB\SHU_MYBASE22.ndf',
	size = 2Mb,
	maxsize = 5Mb,
	filegrowth = 1Mb
)
log on
( 
	name = N'MYBASE_log', 
	filename=N'C:\Projs\DB\MYBASE_log.ldf', 
	size=10240Kb, 
	maxsize=2048Gb, 
	filegrowth=10%
)
go


use SHU_MYBASE2
create table POSITION
(
	POSITION_NAME nvarchar(50) primary key,
	PRIVILEGES nvarchar(20),
	REQUIREMENTS nvarchar(20)
) on G2;

create table EMPLOYEES
(
	ID int primary key,
	SURNAME nvarchar(20),
	NAME nvarchar(20),
	BIRTHDAY date,
	GENDER char(1) CHECK (GENDER in ('м', 'ж')), 
) on G1;

create table ENROLLMENT
(
	DEPARTMENT nvarchar(20) primary key,
	ENROLLMENT_DATA date,
	POSITION_NAME nvarchar(50) constraint POSITION_NAME_FK references POSITION(POSITION_NAME),
	ID int constraint ID_FK references EMPLOYEES(ID)
);


insert into EMPLOYEES 
		values	(123, 'Shumskiy', 'Eugene', '2001-12-14', 'м'),
				(133, 'Черник', 'Евгений', '1993-05-23', 'м'),
				(125, 'Мядель', 'Чимофей', '1945-12-12', 'м'),
				(223, 'Закервашевич', 'Никита', '2012-01-10', 'м');


insert into POSITION (POSITION_NAME, PRIVILEGES, REQUIREMENTS)
		values	('chelovek', '', ''),
				('pchelovek', '', ''),
				('polevaya_bjilka', '', ''),
				('chert', '', '');

insert into ENROLLMENT(DEPARTMENT, ENROLLMENT_DATA)
		values	('slakdf', ''),
				('sadfas', ''),
				('etrert', ''),
				('nfgfgb', '');

use master
go
drop database SHU_MYBASE2