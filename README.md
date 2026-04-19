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

- PWA 対応
  - manifest: /manifest.webmanifest
  - service worker: /service-worker.js
  - オフライン画面: /offline.html

- Rspec での簡単なテスト（Devise）


起動方法
devcontainer内で
```
bin/dev
```

### PWA メモ

- ホーム画面追加時は standalone 表示で起動
- service worker がオフライン時の HTML ナビゲーションを /offline.html へフォールバック
- 主要な公開アセットと PWA 関連ファイルをキャッシュ
