
with graph_data as (
    select
        t.i
        , 1 + ((random() * (12 - 1)))::integer + ((random() * (12 - 1)))::integer as num
    from generate_series(1, 1024 * 2) as t(i)
)

select
    num
    , string_agg('|', '') as graph
from graph_data
group by num
order by num;
