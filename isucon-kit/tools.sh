#!/bin/bash
# 計測ツール一式を入れる。競技サーバ・練習環境どちらでも使える
# usage: sudo ./tools.sh
set -ex

ARCH="$(dpkg --print-architecture)" # amd64 / arm64

apt-get update
apt-get install -y percona-toolkit graphviz htop sysstat unzip jq git make

# alp (nginx アクセスログ集計)
curl -sL "https://github.com/tkuchiki/alp/releases/latest/download/alp_linux_${ARCH}.tar.gz" | tar xz -C /usr/local/bin alp

# pprotein / slp などは必要になったら追加する
alp --version
pt-query-digest --version
