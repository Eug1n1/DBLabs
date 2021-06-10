use SHU_UNIVER
-- 1 задание
select * from TEACHER 
	where PULPIT = 'ИСиТ'
	for xml path


-- 2 задание
select a.AUDITORIUM, au.AUDITORIUM_TYPENAME, a.AUDITORIUM_CAPACITY
	from AUDITORIUM as a	join AUDITORIUM_TYPE as au
	on a.AUDITORIUM_TYPE = au.AUDITORIUM_TYPE
	where a.AUDITORIUM_TYPE like 'ЛК%'
	for xml auto

-- 3 задание
go
declare @h int = 0,
	@x varchar(2000) = '<?xml version="1.0" encoding="windows-1251"?>
			<предметы>
				<предмет сокр="ФКЗ" название_предмета="Футбольный клуб запорожец" кафедра="ИСиТ"/>
				<предмет сокр="Б" название_предмета="Биология" кафедра="ИСиТ"/>
				<предмет сокр="ВИ" название_предмета="Веселые истории" кафедра="ИСиТ"/>
			</предметы>';

exec sp_xml_preparedocument @h output, @x;

insert [SUBJECT] select[сокр], [название_предмета], [кафедра]
			from openxml(@h, '/предметы/предмет',0)
				with([сокр] char(10), [название_предмета] varchar(100), [кафедра] char(20))

select * from [SUBJECT]


-- 4 задание
go
declare @h int = 0,
	@x varchar(2000) = '
			<info>
				<серия>MP</серия>
				<номер_паспорта>123123</номер_паспорта>
				<дата_выдачи>11.12.2018</дата_выдачи>
				<адрес>
					<страна>Красный слоник</страна>
					<город>Оранжевый жирафик</город>
					<улица>Желтый бегимотик</улица>
					<дом>2</дом>
				</адрес>
			</info>',
	@y varchar(2000) = '
			<info>
				<серия>MP</серия>
				<номер_паспорта>234324</номер_паспорта>
				<дата_выдачи>18.03.2019</дата_выдачи>
				<адрес>
					<страна>Желтый бегимотик</страна>
					<город>Красный слоник</город>
					<улица>Оранжевый жирафик</улица>
					<дом>2</дом>
				</адрес>
			</info>',
	@z varchar(2000) = '
			<info>
				<серия>MP</серия>
				<номер_паспорта>345345</номер_паспорта>
				<дата_выдачи>23.02.2020</дата_выдачи>
				<адрес>
					<страна>Оранжевый жирафик</страна>
					<город>Желтый бегимотик</город>
					<улица>Красный слоник</улица>
					<дом>2</дом>
				</адрес>

			</info>',
	@a varchar(2000) = '
			<info>
				<серия>MP</серия>
				<номер_паспорта>456456</номер_паспорта>
				<дата_выдачи>11.10.2021</дата_выдачи>
				<адрес>
					<страна>Красный не слоник</страна>
					<город>Оранжевый не жирафик</город>
					<улица>Желтый не бегимотик</улица>
					<дом>2</дом>
				</адрес>
			</info>';




insert STUDENT(IDGROUP, NAM, BDAY, INFO)
		values( 1, 'Студент1', getdate(), @x),
			(1, 'Студент2', getdate(), @y),
			(1, 'Студент3', getdate(), @z)

update STUDENT set INFO = @a where IDSTUDENT = 1000

select NAM, 
	INFO.value('(/info/серия)[1]', 'varchar(5)')[серия паспорта],
	INFO.value('(/info/номер_паспорта)[1]', 'varchar(15)')[номер_паспорта],
	INFO.query('/info/адрес')[инфо]
	from STUDENT
	where INFO is not null

-- 5 задание

create xml schema collection Student as
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified"
 elementFormDefault="qualified"
 xmlns:xs="http://www.w3.org/2001/XMLSchema">
 <xs:element name="студент">
 <xs:complexType><xs:sequence>
 <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
 <xs:complexType>
 <xs:attribute name="серия" type="xs:string" use="required" />
 <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
 <xs:attribute name="дата" use="required" >
 <xs:simpleType> <xs:restriction base ="xs:string">
 <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
 </xs:restriction> </xs:simpleType>
 </xs:attribute> </xs:complexType>
 </xs:element>
 <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
 <xs:element name="адрес"> <xs:complexType><xs:sequence>
 <xs:element name="страна" type="xs:string" />
 <xs:element name="город" type="xs:string" />
 <xs:element name="улица" type="xs:string" />
 <xs:element name="дом" type="xs:string" />
 <xs:element name="квартира" type="xs:string" />
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
				<xs:element name="серия" type="xs:string" />
				<xs:element name="номер_паспорта" type="xs:string" />
				<xs:element name="дата_выдачи" >
					<xs:simpleType>  
						<xs:restriction base ="xs:string">
							<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
						</xs:restriction> 	
					</xs:simpleType>
				</xs:element>
				<xs:element name="адрес">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="страна" type="xs:string" />
							<xs:element name="город" type="xs:string" />
							<xs:element name="улица" type="xs:string" />
							<xs:element name="дом" type="xs:string" />
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


-- 6 задание
use SHU_MYBASE2
select * from EMPLOYEES
	for xml path

declare @zz varchar(500) = '
			<info>
				<серия>MP</серия>
				<номер_паспорта>345345</номер_паспорта>
				<дата_выдачи>23.02.2020</дата_выдачи>
				<адрес>
					<страна>Оранжевый жирафик</страна>
					<город>Желтый бегимотик</город>
					<улица>Красный слоник</улица>
					<дом>2</дом>
				</адрес>

			</info>';


update EMPLOYEES set INFO = @zz where ID = 125
select INFO
	from EMPLOYEES 
	where INFO is not null

-- 7 задание
use SHU_UNIVER
select FACULTY.FACULTY "@код", 
		(select count(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY)[количество_кафедр],
		(select PULPIT.PULPIT "@код",
			(select TEACHER.TEACHER "@код", TEACHER.TEACHER_NAME "*" from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path('преподаватель'), type)[преподаватели]
			from PULPIT 
			where PULPIT.FACULTY = FACULTY.FACULTY 
			for xml path('кафедра'), type)[кафедры]
	from FACULTY join PULPIT
	on PULPIT.FACULTY = FACULTY.FACULTY
	for xml path('факультет'), type, root('университет')
