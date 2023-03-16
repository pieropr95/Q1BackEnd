-- 01 Titles of movies shot in “black and white” (attribute color is ‘B’) shot after the year 2010 (title_year).

--select MOVIE_TITLE, COLOR, TITLE_YEAR from BDA10.MOVIES where COLOR='B' and TITLE_YEAR>2010;

select MOVIE_TITLE from BDA10.MOVIES where COLOR='B' and TITLE_YEAR>2010;

-- 02 Countries with some production (movie.country) whose budget (budget) exceeds 250 million dollars (>250000000)

--select COUNTRY, BUDGET from BDA10.MOVIES where BUDGET>250000000;

select distinct COUNTRY from BDA10.MOVIES where BUDGET>250000000;

-- 03 Actors and actresses who have not participated in any comedy genre film (UPPER(genre) never has been ‘COMEDY’ for them)

--select TITLE, GENRE from BDA10.GENRES_MOVIES where upper(GENRE)='COMEDY';

--select ACTOR from BDA10.CASTS where TITLE in (select TITLE from BDA10.GENRES_MOVIES where upper(GENRE)='COMEDY');

--select distinct ACTOR from BDA10.CASTS where TITLE in (select TITLE from BDA10.GENRES_MOVIES where upper(GENRE)='COMEDY');

select ACTOR_NAME from BDA10.PLAYERS minus (select distinct ACTOR from BDA10.CASTS where TITLE in (select TITLE from BDA10.GENRES_MOVIES where upper(GENRE)='COMEDY'));

-- 04 For each actress/actor, number of movies starring in each genre, and number of movies in total.

-- FOR EACH ACTOR COUNT MOVIES
--select * from (select ACTOR, count(TITLE) as N_MOVIES from BDA10.CASTS group by ACTOR) where rownum<=20;
--select ACTOR, count(TITLE) as MOVIES_T from BDA10.CASTS group by ACTOR;

-- FOR EACH ACTOR AND GENRE COUNT MOVIES
--select * from BDA10.CASTS join BDA10.GENRES_MOVIES using(TITLE) where rownum<=20;
--select ACTOR, GENRE, count(TITLE) as N_MOVIES from BDA10.CASTS join BDA10.GENRES_MOVIES using(TITLE) group by ACTOR, GENRE;
--select ACTOR, GENRE, count(TITLE) as N_MOVIES from BDA10.CASTS join BDA10.GENRES_MOVIES using(TITLE) group by rollup(ACTOR, GENRE);

with A as (select G.TITLE, G.GENRE, C.ACTOR from BDA10.MOVIES M join BDA10.GENRES_MOVIES G on (M.MOVIE_TITLE=G.TITLE) join BDA10.CASTS C on (M.MOVIE_TITLE=C.TITLE))
select ACTOR, GENRE, count(distinct TITLE) as TOTAL_MOVIES from A group by rollup(ACTOR, GENRE) order by ACTOR, GENRE;

-- 05 The five languages in which more films have been filmed (of those registered in the database)

--select MOVIE_TITLE, FILMING_LANGUAGE from BDA10.MOVIES where rownum<=20;
select * from (select FILMING_LANGUAGE, COUNT(MOVIE_TITLE) as N_MOVIES from BDA10.MOVIES where FILMING_LANGUAGE is not null group by FILMING_LANGUAGE order by N_MOVIES desc) where rownum<=5;

-- 06 For each country of production, most viewed actor (each viewing of a movie counts as the viewing pct /100 points to each actor in its cast).

-- FOR EACH COUNTRY GET MAX_VIEWS AND CORRESPONDING ACTOR
-- TABLES: TAPS_MOVIES (views), CASTS (actor), MOVIES (country)
--select ACTOR, PCT, TITLE from BDA10.CASTS join BDA10.TAPS_MOVIES using (TITLE) where rownum<=20;
--select MOVIE_TITLE, COUNTRY from BDA10.MOVIES where COUNTRY is not null and rownum<=20;

--select * from A join B using (TITLE) where rownum<=20;

with A as (select ACTOR, PCT/100 as PCT, TITLE from BDA10.CASTS join BDA10.TAPS_MOVIES using (TITLE)),
B as (select MOVIE_TITLE as TITLE, COUNTRY from BDA10.MOVIES where COUNTRY is not null),
C as (select ACTOR, COUNTRY, sum(PCT) as VIEWS from A join B using (TITLE) group by ACTOR, COUNTRY),
D as (select COUNTRY, max(VIEWS) as VIEWS from C group by COUNTRY)
select * from C join D using (COUNTRY, VIEWS) order by COUNTRY;
--select ACTOR, max(VIEWS) keep(dense_rank first order by VIEWS desc) abusing from C group by COUNTRY;
--select COUNTRY, max(PCT) from A join B using (TITLE) group by COUNTRY;
--select ACTOR, DURATION from BDA10.CASTS join BDA10.MOVIES on (CASTS.TITLE=MOVIES.MOVIE_TITLE) where rownum<=20;

-- 07 List of film genres along with the player who has participated the most times in a film of that genre. In the event of a tie (several people with the same number of
-- films, which is the maximum number), all tied players will be provided, separated by semicolons.

-- FILM GENRES (GROUP), CASTS (COUNT)
-- tables: GENRES_MOVIES, CASTS

--select listagg(ACTOR, ';') within group (order by ACTOR) as LISTAG from BDA10.GENRES_MOVIES join BDA10.CASTS using (TITLE) where GENRE='Short';

with A as (select * from BDA10.GENRES_MOVIES join BDA10.CASTS using (TITLE)),
B as (select GENRE, ACTOR, count('x') as TIMES from A group by GENRE, ACTOR order by GENRE, TIMES desc),
C as (select B.*, rank() over(partition by GENRE order by TIMES desc) as RNK from B),
D as (select * from C where RNK=1)
select GENRE, TIMES, listagg(ACTOR, ';') within group (order by ACTOR) as ACTORS from D group by GENRE, TIMES;

-- 08 The "cache of a player" in a given year is defined as the sum of income (gross) of the films shot in previous years in which s/he has participated.
-- The movie cache is the summation of its stars’ cache in that filming year. Find the top ten movies with the highest cache.

-- CACHE: FOR EACH PLAYER AND YEAR - SUM OF GROSS (FILM) ACCUMULATED FROM PREVIOUS YEARS

--select MOVIE_TITLE, GROSS from BDA10.MOVIES where GROSS is not null and rownum<=20; 

-- tables: CASTS, MOVIES

with A as (select c.ACTOR, c.TITLE, m.TITLE_YEAR, m.GROSS from BDA10.CASTS c join BDA10.MOVIES m on (c.TITLE=m.MOVIE_TITLE) where m.TITLE_YEAR is not null and m.GROSS is not null),
B as (select A.*, nvl(sum(GROSS) over(partition by ACTOR order by TITLE_YEAR range between unbounded preceding and 1 preceding), 0) CACHE from A),
C as (select TITLE, sum(CACHE) CACHE_T from B group by TITLE),
D as (select TITLE, CACHE_T, row_number() over(order by CACHE_T desc) as RNK from C)
select * from D where RNK<=10;

