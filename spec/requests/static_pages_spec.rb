require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'Root page' do
    it '/ Topページは閲覧不可' do
      get root_path
      expect(response).to have_http_status '302'
    end
  end

  describe "Admin page" do
    it "/adminページは閲覧不可" do
      get rails_admin_path
      expect(response).to have_http_status '302'
    end

    it "管理者は閲覧可能" do
      
    end
  end

  describe 'Root page' do
    it '/admin 正常にレスポンスが返ってくること' do
      get admin_path
      expect(response).to have_http_status '200'
    end
  end

  describe 'Home page Login' do
    user = User.new(email: 'guest@example.com')
    it '正常にゲストログインできること' do
      sign_in user
      get pages_home_path
      expect(response).to have_http_status '200'
    end
  end

  describe 'Home page login Error' do
    valid_user = User.new(email: 'test@test.com', password: '', password_confirmation: 'password')
    it 'ゲストログイン失敗' do
      sign_in valid_user
      expect(response).to be_falsey
    end
  end

  describe 'Home Pageへはログインしないと表示できない' do
    it 'ログインなしでは302' do
      get pages_home_path
      expect(response).to have_http_status '302'
      expect(response).to redirect_to new_user_session_path
    end
  end
end
