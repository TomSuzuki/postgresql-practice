
-- 更新
update memos
set body = '今日のお昼ごはん。'
where memos.title = 'ラーメン';

-- 履歴を確認
with note as (
    select
        memos.title
        , memos.body
        , memos.updated_at as history_at
    from memos
    where
            memos.title = 'ラーメン'
        and memos.deleted_at is null

    union
    select
        memos_history.title
        , memos_history.body
        , memos_history.history_at
    from memos
    inner join memos_history on
            memos_history.deleted_at is null
        and memos_history.memo_id = memos.memo_id
    where
            memos.title = 'ラーメン'
        and memos.deleted_at is null
)

select
    note.title
    , note.body
    , note.history_at
from note
order by note.history_at desc;
