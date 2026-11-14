require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効な属性を持つ場合は有効であること' do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context '異常系' do
      it 'email が空の場合は無効であること' do
        user = build(:user, email: '')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end

      it 'メールアドレスが重複している場合は無効であること' do
        create(:user, email: 'duplicate@example.com')
        duplicated_user = build(:user, email: 'duplicate@example.com')
        expect(duplicated_user).not_to be_valid
        expect(duplicated_user.errors[:email]).to be_present
      end

      it 'password が空の場合は無効であること' do
        user = build(:user, password: '', password_confirmation: '')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to be_present
      end
    end

    context '境界値' do
      it 'パスワードが5文字以下の場合は無効であること' do
        user = build(:user, password: 'a' * 5, password_confirmation: 'a' * 5)
        expect(user).not_to be_valid
        expect(user.errors[:password]).to be_present
      end

      it 'パスワードが6文字以上の場合は有効であること' do
        user = build(:user, password: 'a' * 6, password_confirmation: 'a' * 6)
        expect(user).to be_valid
      end
    end
  end

  describe '管理者権限 (admin)' do
    it 'デフォルトでは admin が false であること' do
      user = create(:user)
      expect(user.admin).to be false
    end

    it 'admin トレイトで作成されたユーザーは admin が true であること' do
      admin_user = create(:user, :admin)
      expect(admin_user.admin).to be true
    end
  end

  describe '.ransackable_attributes' do
    it '検索可能な属性のホワイトリストを返すこと' do
      expected_attributes = %w[created_at email encrypted_password id remember_created_at reset_password_sent_at reset_password_token updated_at]
      expect(User.ransackable_attributes).to match_array(expected_attributes)
    end
  end
end
