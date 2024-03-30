
-- 履歴を一括取得するための関数（メモのUUID, 現在のデータを含めるか）
create or replace function memo_update_history(f1 uuid, f2 bool)
returns table (
    memos_history_id bigint
    , title text
    , body text
    , history_at timestamp without time zone
) as $$

    -- 最新データ
    select
        null::bigint as memos_history_id
        , memos.title
        , memos.body
        , memos.updated_at as history_at
    from memos
    where
            memos.deleted_at is null
        and memos.memo_id = f1
        and f2 = true
    
    -- 履歴データ
    union select
        memos_history.memos_history_id
        , memos_history.title
        , memos_history.body
        , memos_history.history_at
    from memos  -- 親が削除されていた際に取得できないように結合
    inner join memos_history on
            memos_history.deleted_at is null
        and memos_history.memo_id = memos.memo_id
    where
            memos.deleted_at is null
        and memos.memo_id = f1
    order by history_at desc

$$ language sql;

-- 最新を含める
select
    t.memos_history_id
    , t.title
    , t.body
    , t.history_at
from memo_update_history(
    (
        select memos.memo_id
        from memos
        where memos.title = 'ラーメン'
    ), true
) as t (memos_history_id, title, body, history_at);

-- 最新を含めない
select
    t.memos_history_id
    , t.title
    , t.body
    , t.history_at
from memo_update_history(
    (
        select memos.memo_id
        from memos
        where memos.title = 'ラーメン'
    ), false
) as t (memos_history_id, title, body, history_at);
