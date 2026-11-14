# AGENTS.md

このファイルは、AI エージェント（Antigravity、Cursor、Claude Code、GitHub Copilot、Cline など）が本リポジトリで安全・迅速・正確にタスクを実行するためのプロジェクト設計書および作業ガイドラインです。

---

## 1. プロジェクト概要

- **名称**: `practice-Blog`
- **概要**: Ruby on Rails 7 をベースにしたブログ Web アプリケーション。認証（Devise）、管理画面（RailsAdmin + CanCanCan）、Hotwire (Turbo Stream) によるリアルタイムコメント投稿、Tailwind CSS によるスタイリング、テーマ切り替え機能などを備えています。
- **目的**: Web アプリケーションの設計・実装・テスト・運用を網羅的に学ぶための実践的リポジトリ。

---

## 2. 技術スタック & アーキテクチャ

| レイヤー / 領域 | 採用技術 / バージョン | 補足 |
| :--- | :--- | :--- |
| **言語** | Ruby `3.1.6` | `.ruby-version` で指定 |
| **フレームワーク** | Ruby on Rails `~> 7.0.4` | |
| **データベース** | SQLite3 (`1.4`) | `config/database.yml`。Docker Compose には PostgreSQL も定義 |
| **フロントエンド** | Tailwind CSS (`tailwindcss-rails ~> 2.0`), Hotwire (Turbo / Stimulus), Alpine.js | CSS は Foreman (`Procfile.dev`) でビルド監視 |
| **認証 & 認可** | Devise, Devise-i18n, CanCanCan | `admin: boolean` による管理者権限判定 |
| **管理画面** | RailsAdmin (`/admin`) | CanCanCan 連携、Ransack 検索 |
| **ページネーション** | Kaminari | 記事一覧（5件/ページ）など |
| **テスト** | RSpec (`rspec-rails`), Capybara, FactoryBot | `spec/` 配下に格納 |
| **静的解析 / 補完** | RuboCop (`_.rubocop.yml`), Solargraph | VS Code Dev Containers 連携 |
| **実行環境** | Docker / Docker Compose / DevContainer | |

---

## 3. ディレクトリ構成と主要ファイル

```text
practice-Blog/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── posts_controller.rb       # 記事一覧・詳細、前後ナビゲーション、公開制御
│   │   ├── comments_controller.rb    # 記事コメント作成・削除 (Turbo Streams 連携)
│   │   ├── pages_controller.rb       # トップ (home/index)、ゲストログイン処理
│   │   └── theme_controller.rb       # Cookie によるテーマ (dark/light) 切り替え
│   ├── models/
│   │   ├── ability.rb                # CanCanCan 権限定義 (admin のみ RailsAdmin 操作可能)
│   │   ├── category.rb               # カテゴリ
│   │   ├── comment.rb                # コメント (Post に従属、Ransack ホワイトリスト定義)
│   │   ├── post.rb                   # 記事 (enum status: draft/published, Ransack 設定)
│   │   └── user.rb                   # Devise 認証ユーザー (admin カラムを保持)
│   └── views/
│       ├── layouts/application.html.erb # ベースレイアウト (Tailwind, テーマ判定)
│       ├── posts/                    # 記事一覧・詳細テンプレート
│       ├── comments/                 # コメントパーシャル、create.turbo_stream.rb
│       ├── pages/                    # ホーム画面、ゲストログイン用パーシャル
│       └── kaminari/                 # ページネーション用パーシャル
├── config/
│   ├── routes.rb                     # ルーティング定義 (/admin, /posts, /set_theme, ゲストログインなど)
│   ├── database.yml                  # DB 接続設定 (sqlite3 指定)
│   └── environments/                 # 環境別設定 (development, test, production)
├── db/
│   ├── migrate/                      # マイグレーションファイル
│   ├── schema.rb                     # DB スキーマ定義
│   └── seeds.rb                      # 初期データ投入スクリプト
├── spec/
│   ├── factories/                    # FactoryBot 定義
│   ├── models/                       # Model スペック (Category, Comment, Post)
│   ├── requests/                     # Request スペック (Posts, StaticPages)
│   ├── system/                       # System スペック (ゲストログイン等)
│   └── rails_helper.rb / spec_helper.rb
├── .devcontainer/                    # VS Code Dev Container 設定
├── docker-compose.yml                # コンテナ環境定義 (web, db, solargraph)
├── Dockerfile                        # Rails 実行環境用 Dockerfile
├── Procfile.dev                      # Foreman 用プロセス定義 (rails server & tailwindcss:watch)
├── bin/dev                           # 開発サーバー起動用スクリプト
├── _.rubocop.yml                     # RuboCop 設定ファイル (※先頭にアンダースコアあり)
└── README.md                         # 開発者向け概要説明
```

---

## 4. ドメインモデル仕様 & ビジネスロジック

### 4.1 記事 (`Post`)
- **属性**: `title`, `content`, `author`, `date`, `category_id`, `status`
- **公開ステータス (`status`)**:
  - `draft: 0` (下書き), `published: 1` (公開済み)
  - 一般ユーザーは `published` の記事のみ一覧表示および閲覧可能。
  - `draft` 記事の `posts#show` へのアクセスは管理者 (`current_user&.admin?`) のみ許可。一般ユーザーはアラートを表示して `posts_path` へリダイレクトされる。
- **リレーション**: `belongs_to :category`, `has_many :comments`

### 4.2 コメント (`Comment`)
- **属性**: `content`, `post_id`
- **動作**: Turbo Streams (`create.turbo_stream.rb`) を使用して画面リロードなしで投稿・追加表示される。

### 4.3 カテゴリ (`Category`)
- 記事の分類。`posts` テーブルに `category_id` を保持。

### 4.4 ユーザー (`User`) & 権限 (`Ability`)
- **Devise 認証**: メールアドレス・パスワードによる認証。
- **ゲストログイン**: `pages#new_guest` (`POST /pages/guest_sign_in`) を叩くことで、`guest@example.com` でワンクリックログイン可能。
- **管理者フラグ (`admin`)**: `admin: true` のユーザーのみ `/admin` (RailsAdmin) にアクセス可能 (`Ability#initialize` 参照)。

### 4.5 Ransack ホワイトリスト定義
- RailsAdmin および Ransack のセキュリティ仕様により、各モデルで検索対象のカラム・アソシエーションを明示的に許可する必要がある：
  - `self.ransackable_attributes(_auth_object = nil)`
  - `self.ransackable_associations(_auth_object = nil)`
- **注意**: モデルに新規カラムやアソシエーションを追加した際は、上記メソッドへの追加を忘れないこと。

---

## 5. 開発環境の操作・実行コマンド

### 5.1 アプリケーション起動
```bash
# Docker Compose で起動する場合
docker compose up

# ローカル環境で起動する場合 (Foreman 経由で Rails と TailwindCSS を同時起動)
./bin/dev
# または
bin/rails server -p 3000
bin/rails tailwindcss:watch
```

### 5.2 データベース操作
```bash
# マイグレーション実行
bin/rails db:migrate

# ロールバック
bin/rails db:rollback

# テスト DB の準備
bin/rails db:test:prepare

# シードデータ投入
bin/rails db:seed
```

### 5.3 テスト実行
```bash
# 全テスト実行
bundle exec rspec

# 特定のスペックファイルを実行
bundle exec rspec spec/models/post_spec.rb
bundle exec rspec spec/requests/posts_spec.rb
```

### 5.4 コード品質・静的解析
```bash
# RuboCop 実行 (プロジェクトの設定ファイル _.rubocop.yml を明示)
bundle exec rubocop -c _.rubocop.yml

# 自動修正
bundle exec rubocop -c _.rubocop.yml -a
```

---

## 6. AI エージェント向け開発ガイドライン & 注意事項

1. **既存コードスタイルと設計パターンの踏襲**:
   - コントローラに複雑なビジネスロジックを書かず、モデルやヘルパー、サービス層に寄せる。
   - Rails 標準の規約（RESTful ルーティング、Strong Parameters、スコープの活用）に従う。
2. **Tailwind CSS の一貫性**:
   - スタイリングには極力 Tailwind CSS ユーティリティクラスを使用し、アドホックなインラインスタイルや独自のグローバル CSS クラスの濫用を避ける。
   - ダークテーマ切り替え（Cookie: `cookies[:theme]`）を意識し、背景色や文字色がテーマに対応できているか確認する。
3. **セキュリティとアクセス制御の維持**:
   - 管理者専用機能には必ず `current_user&.admin?` または `CanCanCan` (`authorize!`) によるガードを入れる。
   - Mass Assignment 対策として Strong Parameters を適切に設定する。
4. **モデル更新時の Ransack 設定確認**:
   - モデルにカラムを追加・変更した場合は、`ransackable_attributes` の記述を更新すること。
5. **テストの作成・実行**:
   - 新規機能追加やバグ修正を行う際は、`spec/` 配下に対応するスペック（Model Spec, Request Spec, System Spec）を追加または修正すること。
   - 変更後は必ず `bundle exec rspec` を実行して既存テストが破損していないか確認する。
6. **Git コミットと変更のスコープ**:
   - 1つのタスクに対して無関係なファイル（自動生成された一時ファイルや不要な差分）を含めない。
   - コミットメッセージは作業内容が明確にわかるように記述する。


## 7. テストルール & 品質方針

テストコード（RSpec）の作成・修正時は、以下の6つの観点を遵守すること。

### 7.1 テストの網羅性（正常系・異常系・境界値）
- **正常系**:
  - 期待される通常の入力・操作において、処理が正常に完了し期待通りの結果（画面遷移、ステータスコード 200/302、DB レコード作成など）になることを検証する。
  - 例: 公開記事の一覧・詳細表示、有効なパラメータによるコメント投稿、ゲストログイン成功。
- **異常系**:
  - 不正なリクエストや不正な入力値に対して、適切にバリデーションエラーやエラーハンドリング（警告メッセージ表示、リダイレクト等）が行われることを検証する。
  - 認可・権限違反（未ログインユーザーのアクセス、一般ユーザーによる下書き記事へのアクセスや `/admin` へのアクセス拒否）を確実に検証する。
- **境界値**:
  - ページネーションの境界（ちょうど 5 件、6 件目で 2 ページ目が生成されるか）。
  - 文字数制限や数値制限の上限・下限値（最大文字数ちょうど、最大文字数 + 1）。
  - 日時や前後関係の境界（同一時刻、前後の記事が存在しない最初/最後の記事の場合など）。

### 7.2 テストの可読性
- **階層構造の明確化**:
  - `describe` には「テスト対象のクラスやメソッド（例: `#show`, `POST /comments`）」を記述する。
  - `context` には「条件や状況（例: `when post is draft`, `管理者としてログインしている場合`）」を記述する。
  - `it` には「期待される振る舞い・結果（例: `is expected to redirect to posts_path`, `記事一覧が表示されること`）」を端的に記述する。
- **4段階テスト（Setup / Exercise / Verify / Teardown）の意識**:
  - テストの準備（前提データの作成）、実行（アクションの呼び出し）、検証（expect）、後始末を明確に区別し、何がトリガーで何が結果かを一目で把握できるようにする。
- **1テスト1関心事**:
  - 1つの `it` ブロック内で無関係な複数のアサーションを詰め込まず、検証対象の関心事を明確にする。

### 7.3 テストの独立性
- **順序依存の排除**:
  - 各スペック（`it`）は完全に独立して実行可能であり、実行順序や他のテストの結果に依存してはならない（`--order random` でも安定してパスすること）。
- **可変な状態の持ち越し禁止**:
  - クラス変数やグローバル設定、一時ファイルなどをテスト間で共有・変更しない。
- **適切なスコープのデータ作成**:
  - 必要のない `let!` による事前作成の乱用を避け、遅延評価の `let` やインラインでの `build` / `create` を適切に使い分ける。

### 7.4 テストの保守性
- **FactoryBot の活用と Traits の利用**:
  - レコード生成には直接 `Post.create!` を使わず、必ず `FactoryBot` を使用する。
  - 状況ごとのデータ差異は trait（例: `create(:post, :draft)`, `create(:user, :admin)`）で表現し、テストコード側で冗長なパラメータ指定を避ける。
- **過度な DRY よりも DAMP (Descriptive And Meaningful Phrases)**:
  - テストコードにおける過度な共通化・抽象化は可読性を落とすため、テスト内で何が起きているかがその場で読み取れる明瞭さを優先する。

### 7.5 状態遷移のテスト
- **前後の状態変化を明示的に検証**:
  - `change` マッチャを用いて、アクションの実行によってモデルの状態やカウントがどう変化したかを明示する。
  - 例: `expect { subject }.to change { post.reload.status }.from('draft').to('published')`
  - 例: `expect { post_comment }.to change(Comment, :count).by(1)`
- **不正な遷移の抑止**:
  - 許可されていない操作によって不要な状態変更やレコード作成が発生しないこと（`not_to change(...)`）を検証する。

### 7.6 モック・スタブの方針
- **基本原則（ドメインロジックでは実オブジェクトを使用）**:
  - Model Spec や Request Spec では、可能な限りモック（`double`）やスタブ（`allow(...).to receive(...)`）を使わず、DB を利用した実オブジェクトで検証する（過度なモックによるテストの形骸化を防ぐ）。
- **モック・スタブを推奨するケース**:
  - 外部 API との通信（HTTP リクエスト）。
  - 時間に依存する処理（Rails の `travel_to` や Timecop を使用）。
  - 乱数や環境変数など、外部環境によって結果が変わる要素。
- **検証済みモックの利用**:
  - モックを使用する場合は、メソッドの存在やシグネチャを保証できる `instance_double` や verified double を優先して使用する。

---

## 8. コーディングルール
- ファイルの変更後は"rspec"を実行して既存テストが通ることを確認する
- 変更は一つの関心事に絞り小さい単位で行う
- 依頼された範囲以外のコードを変更しない
