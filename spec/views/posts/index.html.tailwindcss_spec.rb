require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  it 'shows post titles' do
    posts = [
      FactoryBot.build_stubbed(:post, title: 'Hello World'),
      FactoryBot.build_stubbed(:post, title: 'Second Post')
    ]

    assign(:posts, Kaminari.paginate_array(posts).page(1).per(5))

    render

    expect(rendered).to include('Hello World')
    expect(rendered).to include('Second Post')
  end
end
