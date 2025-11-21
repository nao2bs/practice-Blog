# Copilot / AI エージェント向け導入メモ

このリポジトリは Rails 7 アプリケーションです。ここでは、AI コーディングエージェントが即座に生産的になれるよう、プロジェクト固有の重要情報・ワークフロー・ファイル参照を簡潔にまとめます。

**Big picture**
- **アプリ種別**: Rails 7 (Ruby 3.1.2) アプリ。主要機能に `Devise`（認証）、`TailwindCSS`、`rails_admin`、`cancancan`、`kaminari` を使用。
- **開発の想定実行環境**: Docker Compose を使ったローカル起動が想定されているが、ローカルで `bin/dev`（Foreman）を直接使うことも可能。
- **ソース構造（代表箇所）**: `app/models`, `app/controllers`, `app/views`, `app/javascript`（packs）

**重要なファイル/場所**
- `README.md`: 起動と目的の概要。
- `Gemfile`: 使用中の gem（Devise, tailwindcss-rails, rspec, solargraph など）。
- `docker-compose.yml` / `Dockerfile`: Docker 起動定義。開発向けに `db`(postgres) と `web` サービスがある。
- `Procfile.dev` + `bin/dev`: 開発時は `foreman` で `web` と `css`（tailwind:watch）を同時起動。
- `config/database.yml`: デフォルトは `sqlite3` 設定だが、`docker-compose.yml` は `postgres` を定義している。どちらを使うかは環境に依存する。
- `spec/`: RSpec テスト群。`spec/rails_helper.rb` を参照。
- `app/views/devise`、`app/controllers`、`app/models`：認証や権限まわりはここを確認。

**プロジェクト特有のワークフロー（必ず確認すること）**
- Docker 起動（推奨、README に準拠）:
  - `docker compose up --build` — サービスをビルド & 起動。
  - コンテナ内で Rails コマンドを実行するには: `docker compose run web bin/rails <task>`（例: `db:migrate`, `console`）。
- ローカル開発（Docker を使わない場合）:
  - `bin/dev` — `Procfile.dev` を用いて `foreman` が `web`（`bin/rails server`）と `css`（`tailwindcss:watch`）を起動する。
  - `bin/dev` は実行時に `foreman` を自動インストールするラッパー。
- マイグレーション:
  - Docker: `docker compose run web bin/rails db:migrate`
  - ローカル: `bin/rails db:migrate`
- テスト:
  - `bundle exec rspec` または `docker compose run web bundle exec rspec`。

**注意点 / 差異（重要）**
- `config/database.yml` はデフォルトで `sqlite3` を使う設定だが、`docker-compose.yml` は `postgres` を立ち上げる構成になっている。Docker 上で PostgreSQL を使う場合、環境変数や `DATABASE_URL` の設定、あるいは `config/database.yml` の切り替えを確認/同期する必要あり。
- `docker-compose.yml` の `web` サービスは起動時に `rm -f tmp/pids/server.pid` を実行して `puma` の PID ロックを回避する（ローカル起動でも同様の問題に注意）。
- フロントエンドは `tailwindcss-rails` を使用しているため、`assets` のビルドや CSS 周りは `bin/rails tailwindcss:watch` を参照。

**コードパターンと慣習（このリポジトリ固有）**
- 認可: `app/models/ability.rb`（`cancancan`）に権限ロジックがある。エンドポイント保護はこことコントローラで確認。
- 管理画面: `rails_admin` を導入している。管理用のカスタム設定は `config/initializers/rails_admin.rb` を確認。
- スコープ: 一部のモデル（例: `site_config.rb`, `category.rb`）が設定やカテゴリを担っている。外部 API 連携は見当たらない（発見できるコードに基づく）。

**編集/変更時の具体的アクション例**
- 新しいマイグレーションを作る: `bin/rails generate migration AddXxxToYyy` → `bin/rails db:migrate`（または Docker 経由）。
- 新しい Devise ビュー変更: `app/views/devise` を編集し、`bin/dev` を再起動して確認。
- 管理画面のカスタム項目: `config/initializers/rails_admin.rb` と `app/models` の `rails_admin` ブロックを確認。

**テスト/静的解析ツール**
- RSpec: `spec/` 以下。テストを実行する前に DB 状態を整える（ローカル: `bin/rails db:test:prepare` 等）。
- Solargraph: `Gemfile` に含まれる。`docker-compose.yml` で `solargraph` サービスを定義しているので、エディタ統合は `7658` ポート経由で可能。

**何を期待するか（AI エージェント向け指示）**
- 変更を提案する際は、まず `README.md`, `Procfile.dev`, `docker-compose.yml`, `config/database.yml` をチェックし、ローカル/コンテナ実行の違いを明示してください。
- DB 関連の変更は `config/database.yml` の環境互換性（sqlite vs postgres）に注意して記述すること。
- 認証/認可に関わる変更は `app/models/ability.rb` と `app/controllers/*`、および `app/views/devise` の衝突を確認してから行うこと。

---
もしこのファイルに追加してほしい「よく使うコマンド」や「調査してほしい箇所」があれば教えてください。必要に応じて既存の `README.md` からの文言マージや、さらに具体例（コマンド実行の出力例など）を追加します。
