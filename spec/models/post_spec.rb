require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効な属性を持つ場合は有効であること' do
        post = build(:post)
        expect(post).to be_valid
      end

      it 'status が published の場合も有効であること' do
        post = build(:post, :published)
        expect(post).to be_valid
      end
    end

    context '異常系' do
      it 'status が nil の場合は無効であること' do
        post = build(:post, status: nil)
        expect(post).not_to be_valid
        expect(post.errors[:status]).to be_present
      end

      it 'category が紐付いていない場合は無効であること' do
        post = build(:post, category: nil)
        expect(post).not_to be_valid
        expect(post.errors[:category]).to be_present
      end
    end
  end

  describe 'enum status' do
    let(:post) { create(:post, :draft) }

    it 'デフォルト値が draft であること' do
      new_post = Post.new
      expect(new_post.status).to eq('draft')
    end

    it 'draft? が正しく判定されること' do
      expect(post.draft?).to be true
      expect(post.published?).to be false
    end

    it 'published? が正しく判定されること' do
      published_post = build(:post, :published)
      expect(published_post.published?).to be true
      expect(published_post.draft?).to be false
    end

    context 'スコープ' do
      let!(:draft_post) { create(:post, :draft) }
      let!(:published_post) { create(:post, :published) }

      it 'Post.draft は下書き記事のみを取得すること' do
        expect(Post.draft).to include(draft_post)
        expect(Post.draft).not_to include(published_post)
      end

      it 'Post.published は公開記事のみを取得すること' do
        expect(Post.published).to include(published_post)
        expect(Post.published).not_to include(draft_post)
      end
    end
  end

  describe '状態遷移' do
    it 'draft から published へステータスを変更できること' do
      post = create(:post, :draft)

      expect { post.published! }
        .to change { post.reload.status }
        .from('draft')
        .to('published')
    end

    it 'published から draft へステータスを変更できること' do
      post = create(:post, :published)

      expect { post.draft! }
        .to change { post.reload.status }
        .from('published')
        .to('draft')
    end
  end

  describe 'アソシエーション' do
    let(:category) { create(:category) }
    let(:post) { create(:post, category: category) }

    it 'Category に属していること' do
      expect(post.category).to eq(category)
    end

    it '複数の Comment を保持できること' do
      comment1 = create(:comment, post: post)
      comment2 = create(:comment, post: post)

      expect(post.comments).to contain_exactly(comment1, comment2)
    end
  end

  describe '.ransackable_attributes' do
    it '検索可能な属性のホワイトリストを返すこと' do
      expected_attributes = %w[author content created_at date id title updated_at]
      expect(Post.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it '検索可能なアソシエーションのホワイトリストを返すこと' do
      expect(Post.ransackable_associations).to eq(['comments'])
    end
  end
end
