
-- �X�V�g���K�isys_updatetd_datetime���X�V����j
-- �Q�l: https://blog.kumano-te.com/activities/auto-update-last-updated-at-postgresql
-- �Q�l: https://kaede.jp/2015/09/25012107/
create or replace function update_trigger() returns trigger as $$
begin
    if (TG_OP = 'UPDATE') then
        NEW.sys_updatetd_datetime := clock_timestamp();  -- now() �� �g�����U�N�V�����̊J�n���� / clock_timestamp() �� ���s���ꂽ����
        return NEW;
    end if;
end;
$$ language plpgsql;

-- ������ۂ��e�[�u��
drop table if exists request_managements;
create table request_managements (
    id bigserial not null
    , request_datetime timestamp without time zone not null
    , request_status varchar(1) not null default '1'
    , sys_inserted_datetime timestamp without time zone not null default now()
    , sys_updatetd_datetime timestamp without time zone not null default now()
    , sys_is_deleted boolean not null default false
    , primary key (id)
);
create trigger update_request_managements_1 before update on request_managements for each row execute procedure update_trigger();

-- ������ۂ��f�[�^
truncate table request_managements restart identity;
insert into request_managements(
    request_datetime
)
select
    current_date + cast(i || ' days' as interval) as request_datetime
from generate_series(1, 5) as t(i)
order by t.i;

-- �X�V���Ă݂�
update request_managements set request_status = '2' where id = 1;

-- ����
select * from request_managements order by id;
