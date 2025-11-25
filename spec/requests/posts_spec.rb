require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /index' do
    context 'when not signed in' do
      it 'redirects to sign in' do
        category = Category.create!(name: 'Test Category')
        Post.create!(title: 'Index Post', content: 'content', author: 'author', date: Date.today, category: category)

        get '/posts'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      it 'returns http success' do
        category = Category.create!(name: 'Test Category')
        Post.create!(title: 'Index Post', content: 'content', author: 'author', date: Date.today, category: category)
        user = FactoryBot.create(:user)
        sign_in user

        get '/posts'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /show' do
    context 'when not signed in' do
      it 'redirects to sign in' do
        category = Category.create!(name: 'Show Category')
        post = Post.create!(title: 'Show Post', content: 'content', author: 'author', date: Date.today,
                            category: category)

        get "/posts/#{post.id}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      it 'returns http success' do
        category = Category.create!(name: 'Show Category')
        post = Post.create!(title: 'Show Post', content: 'content', author: 'author', date: Date.today,
                            category: category)
        user = FactoryBot.create(:user)
        sign_in user

        get "/posts/#{post.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
# require 'rails_helper'

# RSpec.describe 'Posts', type: :request do

# end
