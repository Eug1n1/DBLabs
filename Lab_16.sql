use SHU_UNIVER
-- 1 �������
select * from TEACHER 
	where PULPIT = '����'
	for xml path


-- 2 �������
select a.AUDITORIUM, au.AUDITORIUM_TYPENAME, a.AUDITORIUM_CAPACITY
	from AUDITORIUM as a	join AUDITORIUM_TYPE as au
	on a.AUDITORIUM_TYPE = au.AUDITORIUM_TYPE
	where a.AUDITORIUM_TYPE like '��%'
	for xml auto

-- 3 �������
go
declare @h int = 0,
	@x varchar(2000) = '<?xml version="1.0" encoding="windows-1251"?>
			<��������>
				<������� ����="���" ��������_��������="���������� ���� ���������" �������="����"/>
				<������� ����="�" ��������_��������="��������" �������="����"/>
				<������� ����="��" ��������_��������="������� �������" �������="����"/>
			</��������>';

exec sp_xml_preparedocument @h output, @x;

insert [SUBJECT] select[����], [��������_��������], [�������]
			from openxml(@h, '/��������/�������',0)
				with([����] char(10), [��������_��������] varchar(100), [�������] char(20))

select * from [SUBJECT]


-- 4 �������
go
declare @h int = 0,
	@x varchar(2000) = '
			<info>
				<�����>MP</�����>
				<�����_��������>123123</�����_��������>
				<����_������>11.12.2018</����_������>
				<�����>
					<������>������� ������</������>
					<�����>��������� �������</�����>
					<�����>������ ���������</�����>
					<���>2</���>
				</�����>
			</info>',
	@y varchar(2000) = '
			<info>
				<�����>MP</�����>
				<�����_��������>234324</�����_��������>
				<����_������>18.03.2019</����_������>
				<�����>
					<������>������ ���������</������>
					<�����>������� ������</�����>
					<�����>��������� �������</�����>
					<���>2</���>
				</�����>
			</info>',
	@z varchar(2000) = '
			<info>
				<�����>MP</�����>
				<�����_��������>345345</�����_��������>
				<����_������>23.02.2020</����_������>
				<�����>
					<������>��������� �������</������>
					<�����>������ ���������</�����>
					<�����>������� ������</�����>
					<���>2</���>
				</�����>

			</info>',
	@a varchar(2000) = '
			<info>
				<�����>MP</�����>
				<�����_��������>456456</�����_��������>
				<����_������>11.10.2021</����_������>
				<�����>
					<������>������� �� ������</������>
					<�����>��������� �� �������</�����>
					<�����>������ �� ���������</�����>
					<���>2</���>
				</�����>
			</info>';




insert STUDENT(IDGROUP, NAM, BDAY, INFO)
		values( 1, '�������1', getdate(), @x),
			(1, '�������2', getdate(), @y),
			(1, '�������3', getdate(), @z)

update STUDENT set INFO = @a where IDSTUDENT = 1000

select NAM, 
	INFO.value('(/info/�����)[1]', 'varchar(5)')[����� ��������],
	INFO.value('(/info/�����_��������)[1]', 'varchar(15)')[�����_��������],
	INFO.query('/info/�����')[����]
	from STUDENT
	where INFO is not null

-- 5 �������

create xml schema collection Student as
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified"
 elementFormDefault="qualified"
 xmlns:xs="http://www.w3.org/2001/XMLSchema">
 <xs:element name="�������">
 <xs:complexType><xs:sequence>
 <xs:element name="�������" maxOccurs="1" minOccurs="1">
 <xs:complexType>
 <xs:attribute name="�����" type="xs:string" use="required" />
 <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
 <xs:attribute name="����" use="required" >
 <xs:simpleType> <xs:restriction base ="xs:string">
 <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
 </xs:restriction> </xs:simpleType>
 </xs:attribute> </xs:complexType>
 </xs:element>
 <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
 <xs:element name="�����"> <xs:complexType><xs:sequence>
 <xs:element name="������" type="xs:string" />
 <xs:element name="�����" type="xs:string" />
 <xs:element name="�����" type="xs:string" />
 <xs:element name="���" type="xs:string" />
 <xs:element name="��������" type="xs:string" />
 </xs:sequence></xs:complexType> </xs:element>
 </xs:sequence></xs:complexType>
 </xs:element>
</xs:schema>';

create xml schema collection Student as
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified"
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="info">
		<xs:complexType>
			<xs:sequence>
				<xs:element name="�����" type="xs:string" />
				<xs:element name="�����_��������" type="xs:string" />
				<xs:element name="����_������" >
					<xs:simpleType>  
						<xs:restriction base ="xs:string">
							<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
						</xs:restriction> 	
					</xs:simpleType>
				</xs:element>
				<xs:element name="�����">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="������" type="xs:string" />
							<xs:element name="�����" type="xs:string" />
							<xs:element name="�����" type="xs:string" />
							<xs:element name="���" type="xs:string" />
						</xs:sequence>
					</xs:complexType> 
				</xs:element>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
</xs:schema>';

alter table STUDENT alter column INFO xml(Student);


drop XML SCHEMA COLLECTION Student;	

create xml SCHEMA collection Myschema as
'<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="row">
    <xs:complexType>
      <xs:sequence>
        <xs:element type="xs:byte" name="ID"/>
        <xs:element type="xs:string" name="SURNAME"/>
        <xs:element type="xs:string" name="NAME"/>
        <xs:element type="xs:date" name="BIRTHDAY"/>
        <xs:element type="xs:string" name="GENDER"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'

drop XML SCHEMA COLLECTION Myschema;	


-- 6 �������
use SHU_MYBASE2
select * from EMPLOYEES
	for xml path

declare @zz varchar(500) = '
			<info>
				<�����>MP</�����>
				<�����_��������>345345</�����_��������>
				<����_������>23.02.2020</����_������>
				<�����>
					<������>��������� �������</������>
					<�����>������ ���������</�����>
					<�����>������� ������</�����>
					<���>2</���>
				</�����>

			</info>';


update EMPLOYEES set INFO = @zz where ID = 125
select INFO
	from EMPLOYEES 
	where INFO is not null

-- 7 �������
use SHU_UNIVER
select FACULTY.FACULTY "@���", 
		(select count(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY)[����������_������],
		(select PULPIT.PULPIT "@���",
			(select TEACHER.TEACHER "@���", TEACHER.TEACHER_NAME "*" from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path('�������������'), type)[�������������]
			from PULPIT 
			where PULPIT.FACULTY = FACULTY.FACULTY 
			for xml path('�������'), type)[�������]
	from FACULTY join PULPIT
	on PULPIT.FACULTY = FACULTY.FACULTY
	for xml path('���������'), type, root('�����������')
