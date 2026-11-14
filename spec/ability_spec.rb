require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe '管理者権限の判定' do
    context '管理者ユーザーの場合' do
      let(:user) { build(:user, :admin) }

      it 'rails_admin へのアクセスが許可されること' do
        expect(ability).to be_able_to(:access, :rails_admin)
      end

      it 'すべてのリソースの管理が許可されること' do
        expect(ability).to be_able_to(:manage, :all)
      end
    end

    context '一般ユーザーの場合' do
      let(:user) { build(:user, admin: false) }

      it 'rails_admin へのアクセスが許可されないこと' do
        expect(ability).not_to be_able_to(:access, :rails_admin)
      end

      it 'すべてのリソースの管理が許可されないこと' do
        expect(ability).not_to be_able_to(:manage, :all)
      end
    end

    context '未ログインユーザー (nil) の場合' do
      let(:user) { nil }

      it 'rails_admin へのアクセスが許可されないこと' do
        expect(ability).not_to be_able_to(:access, :rails_admin)
      end

      it 'すべてのリソースの管理が許可されないこと' do
        expect(ability).not_to be_able_to(:manage, :all)
      end
    end
  end
end
