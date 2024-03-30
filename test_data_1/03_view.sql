
-- メモ一覧
select
    memos.memo_id
    , memos.title
    , memos.body
    , (
        select string_agg(tag_name, ' / ' order by tag_name)
        from tag_list
        inner join tags on
                tags.deleted_at is null
            and tags.tag_id = tag_list.tag_id
        where
                tag_list.deleted_at is null
            and tag_list.memo_id = memos.memo_id
    ) as tag
    , memos.created_at
    , memos.updated_at
from memos
where
    memos.deleted_at is null
order by
    memos.title;
