
-- 日時
select
    transaction_timestamp()  -- 実行が開始された日時（nowと同じ）
    , statement_timestamp()  -- SQL文が実行された日時
    , clock_timestamp()      -- 呼び出された日時
    , timeofday()            -- テキスト形式の現在日時（clock_timestampと同じ？）
    , localtimestamp         -- without time zone（nowと同じ？）
;

-- セッション情報
select
	current_database()       -- 現在のデータベース名
    , current_schema()       -- 現在のスキーマ名
    , version()              -- DBのバージョン情報
    , current_user           -- 現在のロール名
    , inet_client_addr()     -- クライアントのIPアドレス
    , inet_client_port()     -- クライアントのポート番号
    , inet_server_addr()     -- サーバのIPアドレス
    , inet_server_port()     -- サーバのポート
;
