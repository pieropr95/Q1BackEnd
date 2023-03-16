--conn bda17/<password>@orcl

alter session set nls_language='English';    --CHANGE LANGUAGE OF SESSION

--DIRECT QUERIES EXERCISES

EX2:

select count(distinct ACTOR) from BDA10.CASTS where TITLE in (select MOVIE_TITLE from BDA10.MOVIES where upper(COUNTRY)='SPAIN');

select distinct ACTOR from BDA10.CASTS where TITLE in (select MOVIE_TITLE from BDA10.MOVIES where upper(COUNTRY)='SPAIN');

--select count(distinct ACTOR) from BDA10.CASTS where TITLE not in (select MOVIE_TITLE from BDA10.MOVIES where upper(COUNTRY)='SPAIN');

select count(distinct ACTOR) from BDA10.CASTS;

SQL> select ACTOR from BDA10.CASTS minus (select ACTOR from BDA10.CASTS where TITLE in (select MOVIE_TITLE from BDA10.MOVIES where upper(COUNTRY)='SPAIN'));
--WHY YOU DONT NEED distinct??

EX3:

select count(DIRECTOR_NAME) from BDA10.MOVIES where MOVIE_FACEBOOK_LIKES>DIRECTOR_FACEBOOK_LIKES;

select count(DIRECTOR_NAME) from BDA10.MOVIES where MOVIE_FACEBOOK_LIKES<=DIRECTOR_FACEBOOK_LIKES;

select count(*) from BDA10.MOVIES;

select DIRECTOR_NAME, DIRECTOR_FACEBOOK_LIKES, MOVIE_FACEBOOK_LIKES from BDA10.MOVIES where MOVIE_FACEBOOK_LIKES>DIRECTOR_FACEBOOK_LIKES and DIRECTOR_NAME is not null;

SQL> select DIRECTOR_NAME from BDA10.MOVIES where MOVIE_FACEBOOK_LIKES>DIRECTOR_FACEBOOK_LIKES and DIRECTOR_NAME is not null;

EX4:

SQL> select MOVIE_TITLE from BDA10.MOVIES where MOVIE_TITLE in (select TITLE from BDA10.SERIES);

EX5:

select COUNTRY from BDA10.MOVIES where upper(COUNTRY)='USA';

select to_number(to_char(sysdate,'YYYY')) as CURRENT_YEAR from dual;

select MOVIE_TITLE, TITLE_YEAR from BDA10.MOVIES where upper(COUNTRY)='USA' and to_number(to_char(sysdate,'YYYY')) - to_number(to_char(TITLE_YEAR)) > 40 order by TITLE_YEAR;

SQL> select MOVIE_TITLE from BDA10.MOVIES where upper(COUNTRY)='USA' and to_number(to_char(sysdate,'YYYY')) - to_number(to_char(TITLE_YEAR)) > 40;

EX6:

select MOVIE_TITLE from BDA10.MOVIES minus (select TITLE from BDA10.TAPS_MOVIES where to_char(view_datetime,'MM')='02');

EX9:
SQL> select * from (select MOVIE_TITLE from BDA10.MOVIES order by TITLE_YEAR) where rownum<2;

select * from dual;    --DUAL is Oracle's smallest table

--ANALYTIC QUERIES EXERCISES

EX2:
--STEP 1
--TAPS_MOVIES: TITLE
--WE NEED TO JOIN TAPS_MOVIES AND CASTS BY TITLE (WE DONT NEED TO JOIN MOVIES BECAUSE IT ADDS NOTHING)
--FOR EACH PLAYER, MONTH means GROUP BY PLAYER, MONTH
--GET PLAYER AND COUNT(VIEWS)

--STEP 2
--GROUP RESULT BY MONTH TO GET THE MAXIMUM TIMES(VIEWS) FOR EVERY MONTH

--STEP 3
--JOIN RESULT1 AND RESULT2 WITH MONTH AND TIMES

--DIRECT
--FOR JOIN, USE using OR on - using IS BETTER WHEN YOU HAVE COLUMNS ON BOTH TABLES WITH THE SAME NAME
with A as (select to_char(VIEW_DATETIME, 'YYYY/MM') MONTH, ACTOR, count('x') TIMES from BDA10.TAPS_MOVIES join BDA10.CASTS using(TITLE) group by to_char(VIEW_DATETIME, 'YYYY/MM'), ACTOR),
B as (select MONTH, max(TIMES) TIMES from A group by MONTH)
select * from A join B using (MONTH, TIMES);

--ANALYTICS
with A as (select to_char(VIEW_DATETIME, 'YYYY/MM') MONTH, ACTOR, count('x') TIMES from BDA10.TAPS_MOVIES join BDA10.CASTS using(TITLE) group by to_char(VIEW_DATETIME, 'YYYY/MM'), ACTOR),
select MONTH, max(ACTOR) keep(dense_rank first order by TIMES desc) abusing from A group by MONTH;

--ASSIGNMENT 1
--------------

SQL> select TABLE_NAME from ALL_TABLES where OWNER='BDA10';

TABLE_NAME
--------------------------------------------------------------------------------
CASTS
CLIENTS
CONTRACTS
GENRES
GENRES_MOVIES
INVOICES
KEYWORDS_MOVIES
LIC_MOVIES
LIC_SERIES
MOVIES
PLAYERS

TABLE_NAME
--------------------------------------------------------------------------------
PRODUCTS
SEASONS
SERIES
TAPS_MOVIES
TAPS_SERIES

16 filas seleccionadas.

SQL> desc BDA10.MOVIES
 Nombre                                    ?Nulo?   Tipo
 ----------------------------------------- -------- ----------------------------
 MOVIE_TITLE                               NOT NULL VARCHAR2(100)
 TITLE_YEAR                                         NUMBER(4)
 COUNTRY                                            VARCHAR2(25)
 COLOR                                              VARCHAR2(1)
 DURATION                                  NOT NULL NUMBER(3)
 GROSS                                              NUMBER(10)
 BUDGET                                             NUMBER(12)
 DIRECTOR_NAME                                      VARCHAR2(50)
 FILMING_LANGUAGE                                   VARCHAR2(20)
 NUM_CRITIC_FOR_REVIEWS                             NUMBER(6)
 DIRECTOR_FACEBOOK_LIKES                            NUMBER(6)
 NUM_VOTED_USERS                                    NUMBER(7)
 NUM_USER_FOR_REVIEWS                               NUMBER(6)
 CAST_TOTAL_FACEBOOK_LIKES                          NUMBER(6)
 FACENUMBER_IN_POSTER                               NUMBER(6)
 MOVIE_IMDB_LINK                                    VARCHAR2(60)
 IMDB_SCORE                                         NUMBER(2,1)
 CONTENT_RATING                                     VARCHAR2(9)
 ASPECT_RATIO                                       NUMBER(4,2)
 MOVIE_FACEBOOK_LIKES                               NUMBER(6)
 
--YOUTUBE - WINDOW FUNCTIONS
--OVER():
-- select e.*, max(salary) over() as MAX_SALARY from EMPLOYEE e;    TOTAL MAX SALARY IN EVERY ROW
-- select e.*, max(salary) over(partition by DEPT_NAME) as MAX_SALARY from EMPLOYEE e;    MAX SALARY FOR EACH DEPT IN EVERY ROW

--RANK():
-- select e.*, rank() over(partition by DEPT_NAME order by SALARY desc) as RNK from EMPLOYEE e;    RANK GIVES A VALUE BASED ON THE ORDER (SKIP VALUES ON DUPLICATES)

--DENSE_RANK():
-- select e.*, dense_rank() over(partition by DEPT_NAME order by SALARY desc) as DENSE_RNK from EMPLOYEE e;    DENSE RANK GIVES A VALUE BASED ON THE ORDER BUT DOESNT SKIP VALUES

--LAG():
--select e.*, lag(SALARY) over(partition by DEPT_NAME order by EMP_ID) as PREV_EMP_SALARY from EMPLOYEE e;    GIVES PREVIOUS RECORD (LIKE LAG OR DELAY)

--LEAD(): NEXT RECORD

--ROWS():
--	UNBOUNDED PRECEDING
--	n PRECEDING
--	CURRENT ROW
--	n FOLLOWING
--	UNBOUNDED FOLLOWING

with A as (select MOVIE_TITLE, GROSS from BDA10.MOVIES where GROSS is not null and rownum<=20)
select A.*, sum(GROSS) over(order by MOVIE_TITLE rows between unbounded preceding and current row) RUNNING_TOTAL from A;