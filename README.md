# README

このサンプルアプリは Rails 7.2 とログイン機能でよく使う Devise、
Tailwind CSS をまとめて Docker Compose で起動するようにパッケージングしたものです。

### バージョン情報

Docker  
Docker-Compose  
Ruby3.1.2  
Rails7.2

### 起動方法

このリポジトリをクローン後、docker compose コマンドで実行。

### 使用している gem

- Devise
- Tailwind CSS

### 機能詳細

- Top ページ  
  http://localhost:3000/

- Devise のサインアップ機能  
  http://localhost:3000/users/sign_up

- Devise のログイン機能  
  http://localhost:3000/users/sign_in

- ゲストユーザーログイン

- Rspec での簡単なテスト（Devise）
