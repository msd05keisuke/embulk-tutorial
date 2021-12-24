# embulkを使ってみる
![Test Image 3](./img/embulk.png)
# embulkとは？
オープンソースの並列バルクデータローダーで、プラグインベースでいろいろな入出力先に対応している．

# embulkの特徴
プラグインベースの作りでInput、Output部とデータ処理を行うExecutor部からなっている．Executor部はJavaによる実装で、Input、Output プラグインは、JavaやRubyの実装がある.Rubyを処理するためにJRubyが使われている．Input、Outputに関するものがメインだが、3rd-partyを含め多数のプラグインがRubyGemとして提供されている．また望みのプラグインがない場合には、RubyやJava（Scalaなど）で開発が可能．

# 今回の流れ

Input(MySQL) ---> embulk ---> Output(MySQL)

# 実行する前に....
### データベース設計
docker-composeで立ち上げる！ 立ち上げるだけで以下の構成で作成される．
- Input<br>
データベース名: db_input<br> テーブル名: input<br>
カラム: id(int, pk), name(varchar10)<br>
~~~
# 初期データ ./input/init/init.sql
insert into input(name) values('hogehoge');
insert into input(name) values('poyopoyo');
~~~
- Output<br>
データベース名: db_output<br> テーブル名: output<br>
カラム: id(int, pk), name(varchar10)


### embulkのymlファイルの書き方
~~~
# Input側のこと
in:
  type: mysql
  host: db_input
  database: db_input
  user: root
  password: password
  table: "input"
  select: "*"

# Output側のこと
out:
  type: mysql
  host: db_output
  database: db_output
  user: root
  password: password
  table: "output"
  mode: insert   # 他にもmergeなどがある
~~~


# 実行

### コンテナ立ち上げ
~~~
$ docker-compose up -d
~~~

### 実行前のinputテーブル
~~~
# db_inputコンテナに入って確認
mysql> SELECT*FROM input;
+----+----------+
| id | name     |
+----+----------+
|  1 | hogehoge |
|  2 | poyopoyo |
+----+----------+
~~~
#### 実行前のoutputテーブル
~~~
mysql> SELECT*FROM output;
~~~
### embulkを動かす
~~~
# embulkのコンテナにはいって以下を実行
$ embulk run config.yml 
~~~~~~~~略~~~~~~~~
2021-12-24 16:21:19.559 +0000 [INFO] (main): Committed.
2021-12-24 16:21:19.560 +0000 [INFO] (main): Next config diff: {"in":{},"out":{}}
~~~


#### 実行後のoutputテーブル
成功していれば、下記のようにinputのデータをoutputに流すことができている．
~~~
mysql> SELECT*FROM output;
+----+----------+
| id | name     |
+----+----------+
|  1 | hogehoge |
|  2 | poyopoyo |
+----+----------+
~~~



