--------4B----
set transaction isolation level read committed
begin tran
	select @@SPID
	insert into FACULTY values ('��Aa','������ a �� �� ������')
	update FACULTY set FACULTY = '��' where FACULTY = '�'
	-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback tran

--- 5B ---
select * from FACULTY
set transaction isolation level READ COMMITTED
begin transaction
-------------------------- t1 --------------------
	update FACULTY set FACULTY = '����a' where FACULTY = '����'

commit tran;
-------------------------- t2 --------------------
update FACULTY set FACULTY = '������' where FACULTY = '����a'

--- 6B ---
begin transaction
-------------------------- t1 --------------------
insert [SUBJECT] values ('NewSubject', 'NS', '����');
-------------------------- t2 --------------------
commit;

delete from [SUBJECT] where SUBJ = 'NewSubj2'

--- 7B ---
set transaction isolation level READ COMMITTED
begin transaction
insert [SUBJECT] values ('NewSubj2', 'NSubj2', '����');
update [SUBJECT] set SUBJECT_NAME = 1 where SUBJ = 'NewSubjs2'
select * from [SUBJECT] as s  where s.PULPIT= '����';
-------------------------- t1 --------------------
commit;
select * from [SUBJECT] as s where s.PULPIT = '����';
-------------------------- t2 --------------------

dbcc useroptions	
