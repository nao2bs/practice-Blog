require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /index' do
    it 'returns http 302' do
      # Arrange: Create necessary data
      user = User.create!(email: 'test@example.com', password: 'password')
      sign_in user

      # Act: Perform the request
      get posts_path

      # Assert: Check the response
      expect(response).to have_http_status(:found) # 302 is :found
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      # Arrange: Create necessary data
      user = User.create!(email: 'test@example.com', password: 'password')
      post = Post.create!(title: 'Sample Post', content: 'This is a test post.', user: user)

      # Act: Perform the request
      get post_path(post)

      # Assert: Check the response
      expect(response).to have_http_status(:success)
    end
  end
end
