require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET /index' do
    it 'redirects to sign in' do
      category = Category.create!(name: 'Test Category')
      Post.create!(title: 'Index Post', content: 'content', author: 'author', date: Date.today, category: category)

      get '/posts'
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET /show' do
    it 'redirects to sign in' do
      category = Category.create!(name: 'Show Category')
      post = Post.create!(title: 'Show Post', content: 'content', author: 'author', date: Date.today,
                          category: category)

      get "/posts/#{post.id}"
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  # factories/users.rb
  FactoryBot.define do
    factory :guest_user, class: User do
      # ユーザー名
      # name { 'テストユーザー' }
      # メールアドレス
      email { 'guestuser@example.com' }
      # パスワード
      password { 'password' }
    end

    factory :admin_user, class: User do
      email { 'adminuser@example.com' }
      password { 'password' }
      # 管理者フラグ
      admin { true }
    end
  end

  describe 'Home page' do
    example 'root_pathは閲覧不可' do
      get root_path
      expect(response).to have_http_status '302'
    end

    example 'ログイン画面に未ログイン警告を表示しないこと' do
      get root_path
      follow_redirect!

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include(I18n.t('devise.failure.unauthenticated'))
      expect(response.body).not_to include('Translation missing')
    end

    example 'admin_pathは閲覧不可' do
      get rails_admin_path
      expect(response).to have_http_status '302'
    end
  end

  describe 'Admin page' do
    example '管理者は閲覧可能' do
      admin = FactoryBot.create(:admin_user)
      sign_in admin
      get rails_admin_path
      expect(response).to have_http_status '200'
    end
  end

  describe 'ゲストユーザーログイン' do
    example 'root_pathへ正常にログインできること' do
      guest = FactoryBot.create(:guest_user)
      sign_in guest
      get root_path
      expect(response).to have_http_status '200'
    end

    example 'パスワードを間違えてログインに失敗すること' do
      guest = FactoryBot.create(:guest_user)
      post user_session_path, params: { user: { email: guest.email, password: 'wrong_password' } }
      expect(response).to have_http_status '422'
      expect(response.body).to include('メールアドレスまたはパスワードが正しくありません。')
      expect(response.body).not_to include('Translation missing')
    end

    example 'メールアドレスを間違えてログインに失敗すること' do
      guest = FactoryBot.create(:guest_user)
      post user_session_path, params: { user: { email: 'wrong_email', password: guest.password } }
      expect(response).to have_http_status '422'
      expect(response.body).to include('メールアドレスまたはパスワードが正しくありません。')
      expect(response.body).not_to include('Translation missing')
    end
  end

  # describe 'Admin page' do
  #   it '/adminページは閲覧不可' do
  #     get rails_admin_path
  #     expect(response).to have_http_status '302'
  #   end

  #   it '管理者は閲覧可能' do
  #     sign_in admin
  #     get rails_admin_path
  #     expect(response).to have_http_status '200'
  #   end
  # end

  # describe 'Root page' do
  #   it '/admin 正常にレスポンスが返ってくること' do
  #     get admin_path
  #     expect(response).to have_http_status '200'
  #   end
  # end

  # describe 'Home page Login' do
  #   it '正常にゲストログインできること' do
  #     sign_in user
  #     get root_path
  #     expect(response).to have_http_status '200'
  #   end
  # end

  # describe 'Home page login Error' do
  #   # valid_user = User.new(email: 'test@test.com', password: '', password_confirmation: 'password')
  #   # it 'ゲストログイン失敗' do
  #   #   sign_in valid_user
  #   #   expect(response).to be_falsey
  #   # end
  # end
end
