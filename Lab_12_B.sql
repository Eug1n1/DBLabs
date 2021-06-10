--------4B----
set transaction isolation level read committed
begin tran
	select @@SPID
	insert into FACULTY values ('ПФAa','просто a но не просто')
	update FACULTY set FACULTY = 'ФФ' where FACULTY = 'Ф'
	-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback tran

--- 5B ---
select * from FACULTY
set transaction isolation level READ COMMITTED
begin transaction
-------------------------- t1 --------------------
	update FACULTY set FACULTY = 'аПППa' where FACULTY = 'ПППП'

commit tran;
-------------------------- t2 --------------------
update FACULTY set FACULTY = 'ПППППП' where FACULTY = 'аПППa'

--- 6B ---
begin transaction
-------------------------- t1 --------------------
insert [SUBJECT] values ('NewSubject', 'NS', 'ИСиТ');
-------------------------- t2 --------------------
commit;

delete from [SUBJECT] where SUBJ = 'NewSubj2'

--- 7B ---
set transaction isolation level READ COMMITTED
begin transaction
insert [SUBJECT] values ('NewSubj2', 'NSubj2', 'ИСиТ');
update [SUBJECT] set SUBJECT_NAME = 1 where SUBJ = 'NewSubjs2'
select * from [SUBJECT] as s  where s.PULPIT= 'ИСиТ';
-------------------------- t1 --------------------
commit;
select * from [SUBJECT] as s where s.PULPIT = 'ИСиТ';
-------------------------- t2 --------------------

dbcc useroptions	
