require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'レコード作成' do
    context '正常系' do
      it '有効な属性を持つ場合は有効であること' do
        category = build(:category, name: 'テクノロジー')
        expect(category).to be_valid
      end

      it 'カテゴリを保存すると Category の総数が1件増えること' do
        expect {
          create(:category, name: 'プログラミング')
        }.to change(Category, :count).by(1)
      end
    end
  end

  describe '記事との関連' do
    let(:category) { create(:category, name: 'Rails') }

    it 'このカテゴリに関連付けられた記事を作成できること' do
      post = create(:post, category: category)
      expect(post.category).to eq(category)
    end
  end
end
