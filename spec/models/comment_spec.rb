require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効な属性を持つ場合は有効であること' do
        comment = build(:comment)
        expect(comment).to be_valid
      end
    end

    context '異常系' do
      it 'content が nil の場合は無効であること' do
        comment = build(:comment, content: nil)
        expect(comment).not_to be_valid
        expect(comment.errors[:content]).to be_present
      end

      it 'content が空文字の場合は無効であること' do
        comment = build(:comment, content: '')
        expect(comment).not_to be_valid
        expect(comment.errors[:content]).to be_present
      end

      it 'post が紐付いていない場合は無効であること' do
        comment = build(:comment, post: nil)
        expect(comment).not_to be_valid
        expect(comment.errors[:post]).to be_present
      end
    end
  end

  describe 'アソシエーション' do
    let(:post) { create(:post) }
    let(:comment) { create(:comment, post: post) }

    it 'Post に属していること' do
      expect(comment.post).to eq(post)
    end
  end

  describe 'レコード作成' do
    let(:post) { create(:post) }

    it 'コメントを保存すると Comment の総数が1件増えること' do
      expect {
        create(:comment, post: post)
      }.to change(Comment, :count).by(1)
    end
  end

  describe '.ransackable_attributes' do
    it '検索可能な属性のホワイトリストを返すこと' do
      expected_attributes = %w[content created_at id post_id updated_at]
      expect(Comment.ransackable_attributes).to match_array(expected_attributes)
    end
  end
end
