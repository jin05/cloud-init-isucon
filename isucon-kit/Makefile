# ISUCON 用ユーティリティ。リポジトリ直下 (例: /home/isucon/webapp) にコピーして使う
# 初期値は ISUCON14 (isuride) 用。問題ごとに下の変数だけ書き換えること

SERVICE   ?= isuride-go.service
APP_DIR   ?= /home/isucon/webapp/go
BUILD     ?= go build -o isuride .
NGINX_LOG ?= /var/log/nginx/access.log
SLOW_LOG  ?= /var/log/mysql/mysql-slow.log
DB_SVC    ?= mysql
# /api/users/123 のような可変パスをまとめる正規表現 (カンマ区切り)
ALP_M     ?= "^/api/users/[^/]+$$,^/api/items/[^/]+$$"
RESULT    ?= /tmp/isucon-result

.PHONY: deploy build restart rotate alp slow pprof bench-prep log-off

## ビルドして再起動
deploy: build restart

build:
	cd $(APP_DIR) && $(BUILD)

restart:
	sudo systemctl restart $(SERVICE)
	sudo systemctl restart nginx
	sudo systemctl restart $(DB_SVC)

## ベンチ前にログを空にする (毎回これ→ベンチ→alp/slow)
rotate:
	sudo truncate -s 0 $(NGINX_LOG) || true
	sudo truncate -s 0 $(SLOW_LOG) || true

bench-prep: rotate restart

## nginx アクセスログ集計 (合計時間順)
alp:
	@mkdir -p $(RESULT)
	sudo alp ltsv --file $(NGINX_LOG) -m $(ALP_M) --sort sum -r \
		-o count,method,uri,min,avg,max,sum,2xx,4xx,5xx | tee $(RESULT)/alp-$$(date +%H%M%S).txt

## スロークエリ集計
slow:
	@mkdir -p $(RESULT)
	sudo pt-query-digest $(SLOW_LOG) | tee $(RESULT)/slow-$$(date +%H%M%S).txt | head -n 200

## Go アプリの pprof (net/http/pprof を :6060 で起動しておく)
pprof:
	go tool pprof -http=0.0.0.0:1080 http://localhost:6060/debug/pprof/profile?seconds=60

## 最終提出前: スロークエリログ停止
log-off:
	sudo mysql -e "SET GLOBAL slow_query_log = 0;"
