# ISUCON 自走ルール (Claude Code 用)

このファイルを競技サーバの作業ディレクトリ (例: /home/isucon/webapp) に置いて使う。

## ゴール
ベンチマークのスコアを最大化する。減点・Fail を出さないことがスコアより優先。

## 禁止
- DB のデータ削除・初期データの変更、`DROP` / `TRUNCATE` (初期化処理を除く)
- 採点ルール・マニュアルに反する変更 (レスポンス仕様の変更、キャッシュによる整合性崩れ)
- `git push --force`、履歴の書き換え
- `/etc` 配下を git 管理外で変更すること

## ループ
1. `make bench-prep` → ベンチ実行 → スコアを `SCORES.md` に追記 (時刻・コミット・スコア・メモ)
2. `make alp` / `make slow` / pprof でボトルネックを 1 つ決める (推測で決めない)
3. 最小の変更で直す → `make deploy` → ベンチ
4. スコアが上がったら commit、下がった or Fail なら即 `git revert`
5. 30 分ごとに進捗を短く報告する

## 終了 1 時間前
- `make log-off`、nginx access_log off、pprof 削除
- 再起動試験 (`sudo reboot` → 自動起動を確認) → 最終ベンチ
- 以降は大きな変更をしない
