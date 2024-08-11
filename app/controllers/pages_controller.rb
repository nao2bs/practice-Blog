class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:home]
  # skip_before_action :verify_authenticity_token

  def index
    @title = 'index'
  end

  def home
    @title = 'home'
  end

  def new_guest
    user = User.find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
