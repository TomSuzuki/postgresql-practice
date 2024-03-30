
-- UUID
select gen_random_uuid() from generate_series(1, 10);

-- ランダム（0～99）
select (random() * 10000)::integer % 100 from generate_series(1, 10);

-- ランダムな文字列
select md5(random()::text) from generate_series(1, 10);

-- ランダムな日付（システム日～1年後）
select (current_date + (random() * (timestamp '0001-12-31' - timestamp '0001-01-01')))::date from generate_series(1, 10);

-- ランダムなひらがな（カタカナの場合は12353を12449に変更する）
select
    string_agg(c, '')
from (select i, chr(12353 + (random() * 1000)::integer % 85) from generate_series(1, 5 * 10) as i) as t(i, c)
group by i % 10;
