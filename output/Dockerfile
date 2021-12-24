# mysqlのバージョン
FROM mysql:8.0

# 3306ポート開放
EXPOSE 3306

# MySQL設定ファイルをイメージ内にコピー
ADD ./my.cnf /etc/mysql/conf.d/my.cnf

# 実行されるところ
CMD ["mysqld"]
