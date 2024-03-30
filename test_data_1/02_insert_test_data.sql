
-- メモ
truncate memos restart identity;
insert into memos (title, body)
values
    ('寿司', 'おいしい。')
    , ('焼き肉', 'おいしい。')
    , ('ラーメン', 'おいしい。')
    , ('本', '食べられない。')
    , ('テレビ', '食べられない。');

-- タグ
truncate tags restart identity;
insert into tags (tag_name)
values
    ('食べ物')
    , ('食べれないもの')
    , ('高いもの');

-- タグリスト
insert into tag_list (memo_id, tag_id)
select
    (select memo_id from memos where memos.title = _t.title limit 1) as memo_id
    , (select tag_id from tags where tags.tag_name = _t.tag_name limit 1) as tag_id
from (
    values
        ('寿司', '食べ物')
        , ('寿司', '高いもの')
        , ('焼き肉', '食べ物')
        , ('ラーメン', '食べ物')
        , ('本', '食べれないもの')
        , ('テレビ', '食べれないもの')
        , ('テレビ', '高いもの')
) as _t (title, tag_name);

