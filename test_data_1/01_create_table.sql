
-- 共通トリガ
create or replace function update_trigger() returns trigger as $$
begin
    if (TG_OP = 'UPDATE') then
        NEW.updated_at := now();
        return NEW;
    end if;
    return null;
end;
$$ language plpgsql;

-- メモ履歴トリガ
create or replace function update_history() returns trigger as $$
begin
    if (TG_OP = 'UPDATE') then
        insert into memos_history (
            memo_id
            , title
            , body
            , history_at
        )
        values (
            OLD.memo_id
            , OLD.title
            , OLD.body
            , OLD.updated_at
        );
    end if;
    return null;
end;
$$ language plpgsql;

-- メモ
drop table if exists memos;
create table memos (
    memo_id uuid not null default gen_random_uuid()
    , title text not null
    , body text not null default ''
    , created_at timestamp without time zone not null default now()  -- 共通列（作成日時）
    , updated_at timestamp without time zone not null default now()  -- 共通列（更新日時）
    , deleted_at timestamp without time zone default null  -- 共通列（削除日時）
    , primary key (memo_id)
);
create trigger update_memos_1 before update on memos for each row execute procedure update_trigger();
create trigger update_memos_2 after update on memos for each row execute procedure update_history(); 

-- メモ履歴
drop table if exists memos_history;
create table memos_history (
    memos_history_id bigserial not null
    , memo_id uuid not null
    , title text not null
    , body text not null default ''
    , history_at timestamp without time zone not null default now()  -- 履歴系の共通列
    , created_at timestamp without time zone not null default now()
    , updated_at timestamp without time zone not null default now()
    , deleted_at timestamp without time zone default null
    , primary key (memos_history_id)
);
create trigger update_memos_history_1 before update on memos_history for each row execute procedure update_trigger();

-- タグリスト
drop table if exists tag_list;
create table tag_list (
    tag_list_id bigserial not null
    , memo_id uuid not null
    , tag_id uuid not null
    , created_at timestamp without time zone not null default now()
    , updated_at timestamp without time zone not null default now()
    , deleted_at timestamp without time zone default null
    , primary key (tag_list_id)
);
create unique index on tag_list (memo_id, tag_id) where deleted_at is null;
create trigger update_tag_list_1 before update on tag_list for each row execute procedure update_trigger(); 

-- タグ
drop table if exists tags;
create table tags (
    tag_id uuid not null default gen_random_uuid()
    , tag_name text not null default ''
    , created_at timestamp without time zone not null default now()
    , updated_at timestamp without time zone not null default now()
    , deleted_at timestamp without time zone default null
    , primary key (tag_id)
);
create trigger update_tags_1 before update on tags for each row execute procedure update_trigger(); 
