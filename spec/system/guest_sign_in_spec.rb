require 'rails_helper'

RSpec.describe 'Guest sign in', type: :system do
  before do
    driven_by :rack_test
  end

  it 'shows Hello world! ログインしています after clicking guest sign-in' do
    visit root_path

    # ensure the button exists and click it
    expect(page).to have_button('ゲストログイン(閲覧用)')
    click_button 'ゲストログイン(閲覧用)'

    # after signing in, pages#home should render the content
    expect(page).to have_content('Hello world!')
    expect(page).to have_content('ログインしています')
  end

  # ログアウトのボタンを押すとログアウトできていることを確認するテストを追加
  it 'allows guest user to log out' do
    visit root_path

    # ゲストログインボタンをクリック
    click_button 'ゲストログイン(閲覧用)'

    # ログアウトボタンが存在することを確認してクリック
    expect(page).to have_button('ログアウト')
    click_button 'ログアウト'

    # ログアウト後、再びゲストログインボタンが表示されることを確認
    expect(page).to have_button('ゲストログイン(閲覧用)')
  end
end
