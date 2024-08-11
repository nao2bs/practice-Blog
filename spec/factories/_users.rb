# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    # メールアドレス
    email { 'test10@gmail.com' }
    # パスワード
    password { 'password' }
    # パスワード確認
    password_confirmation { 'password' }
  end

  factory :admin do
    email { 'test2@gmail.com' }
    password { 'password' }
    password_confirmation { 'password' }
    # 管理者フラグ
    admin { true }
  end
end
