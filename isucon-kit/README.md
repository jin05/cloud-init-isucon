# isucon-kit

本番 (2026/10/31) に向けた練習＆当日用キット。

| ファイル | 用途 |
| --- | --- |
| `tools.sh` | alp / pt-query-digest / htop など計測ツールを一括導入 (`sudo ./tools.sh`) |
| `Makefile` | deploy・ログローテ・alp・スロークエリ集計・pprof。リポジトリ直下にコピーして変数を書き換える |
| `conf/nginx-log.conf` | alp 用 LTSV ログフォーマット |
| `conf/mysql-slow.cnf` | スロークエリログ (全件) 有効化 |

## 練習プラン (10/27〜10/30)

| 日付 | やること |
| --- | --- |
| 10/27 | `isucon14` 環境を構築 (下記)。初期スコア確認・`tools.sh` 実行・git 管理化まで通しでやる |
| 10/28 | ISUCON14 を 8 時間通しで解く。計測 → 改善 → 再計測のループを回す |
| 10/29 | 講評・上位チームのリポジトリを読んで取りこぼした改善を再現。`isucon13` で初動だけ再練習 |
| 10/30 | 当日手順の確認・役割分担・SSH 鍵/ポータル/Discord 等の事前準備。早めに寝る 😴 |

```sh
multipass launch --name isucon14 --cpus 2 --disk 32G --memory 4G --timeout 3600 \
  --cloud-init ../isucon14/isucon14.cfg 24.04
```

## 当日チェックリスト

### 最初の 1 時間 (初動)
- [ ] 当日マニュアル・アプリマニュアルを全員で読む (採点ルール・減点条件を最優先)
- [ ] 初期ベンチを回してスコアを記録
- [ ] `/home/isucon` 配下と `/etc/nginx` `/etc/mysql` を git 管理して push
- [ ] サーバのスペック・構成確認 (`nproc`, `free -h`, `systemctl list-units --type=service`)
- [ ] 実装言語を Go に切り替え (速い・pprof が使える)
- [ ] `tools.sh` 実行、nginx LTSV ログ / スロークエリログを有効化
- [ ] Makefile の変数を問題に合わせて修正、`make bench-prep` → ベンチ → `make alp` `make slow`

### 改善ループ
- [ ] ボトルネックは必ず計測で決める (alp の sum 上位・pt-query-digest の上位)
- [ ] 定番: インデックス追加 / N+1 解消 / 不要な `SELECT *` 削減 / 静的ファイルを nginx から配信
- [ ] 定番: DB 接続数・`max_connections`、Go の `SetMaxOpenConns`、nginx の upstream keepalive
- [ ] 1 変更ごとにベンチ → スコアと変更内容をメモ (落ちたらすぐ revert)
- [ ] 複数台構成を活かす (DB 分離など) のは計測で CPU が張り付いてから

### 終了 1 時間前
- [ ] 計測系を停止: スロークエリログ off (`make log-off`)、nginx access_log off、pprof 削除
- [ ] 全台再起動してアプリが自動起動するか確認 (**再起動試験は必須**)
- [ ] 再起動後にブラウザで動作確認 → 最終ベンチ
- [ ] 終了 30 分前以降は大きな変更をしない
