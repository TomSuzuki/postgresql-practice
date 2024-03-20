
-- 更新トリガ（sys_updatetd_datetimeを更新する）
-- 参考: https://blog.kumano-te.com/activities/auto-update-last-updated-at-postgresql
-- 参考: https://kaede.jp/2015/09/25012107/
create or replace function update_trigger() returns trigger as $$
begin
    if (TG_OP = 'UPDATE') then
        NEW.sys_updatetd_datetime := clock_timestamp();  -- now() → トランザクションの開始時間 / clock_timestamp() → 実行された時間
        return NEW;
    end if;
end;
$$ language plpgsql;

-- それっぽいテーブル
drop table if exists request_managements;
create table request_managements (
    id bigserial not null
    , request_datetime timestamp without time zone not null
    , usage_date date not null
    , request_status varchar(1) not null default '1'
    , sys_inserted_datetime timestamp without time zone not null default now()
    , sys_updatetd_datetime timestamp without time zone not null default now()
    , sys_is_deleted boolean not null default false
    , primary key (id)
);
create trigger update_request_managements_1 before update on request_managements for each row execute procedure update_trigger();  -- 更新トリガ
create index request_managements__usage_date on request_managements (usage_date);
create index request_managements__request_date on request_managements ((request_datetime::date));  -- 式インデックス

-- それっぽいデータ
truncate table request_managements restart identity;
insert into request_managements(
    request_datetime
    , usage_date
)
select
    current_date - (random() * (timestamp '0001-12-31 23:59:59' - timestamp '0001-01-01 00:00:00')) as request_datetime
    , current_date + (random() * (timestamp '0001-12-31' - timestamp '0001-01-01')) as usage_date
from generate_series(1, 1024 * 128) as t(i)
order by t.i;

-- 更新してみる
update request_managements set request_status = '2' where id = 1;

-- 完了
select
    usage_date
    , count(*) as request_num
    , min(request_datetime) as min_request_datetime
    , max(request_datetime) as miax_request_datetime
from request_managements
group by usage_date
order by count(*) desc
limit 10;
