
begin;
drop table if exists sample1;
create temp table sample1 (i int);
select i from generate_series(1, 10) as i;
commit;

