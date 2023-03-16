--conn bda17/<password>@orcl

alter session set nls_language='English';    --CHANGE LANGUAGE OF SESSION

password	--CHANGE PASSWORD

SQL> create table CLIENT(
  2  DNI        char(9),
  3  NAME       varchar2(20),
  4  SURNAME    varchar2(25) NOT NULL,
  5  EMAIL      varchar2(50),
  6  BIRTHDATE  date,
  7  DEGREE     number (5,2),
  8  constraint pk_client primary key (DNI),
  9  constraint uk_client unique (EMAIL),
 10  constraint ck_client check (DEGREE<=10)
 11  );
 
nullary function, unary function, binary function (date)

sysdate: Current day

SQL> insert into CLIENT values('12345678X','John','Doe','johndoe@email.com',sysdate-10000,null);
insert into CLIENT values('87654321X','Jane','Doe','janedoe@email.com',sysdate-10005,null);

SQL> select * from CLIENT;

--FORMAT:
set wrap off
set linesize 2000
desc user_tables

select TABLE_NAME from USER_TABLES;

drop table CLIENT;

SQL> select TABLE_NAME from ALL_TABLES where OWNER='BDA10';

SQL> select * from CLIENT where NAME LIKE 'J%n';

WHERE rownum<10    ## LIMIT does not work in Oracle

EX1:

SQL> select TITLE_YEAR from BDA10.MOVIES where upper(MOVIE_TITLE)='AVATAR';

TITLE_YEAR
----------

--NULL RESULT, USE nvl

SQL> select nvl(to_char(TITLE_YEAR),'NA') from BDA10.MOVIES where upper(MOVIE_TITLE)='AVATAR';

NVL(TO_CHAR(TITLE_YEAR),'NA')
----------------------------------------
NA

--CAPTION OF THE RESULT TOO LONG, USE as

SQL> select nvl(to_char(TITLE_YEAR),'NA') as YEAR from BDA10.MOVIES where MOVIE_TITLE='Avatar';

YEAR
----------------------------------------
NA
