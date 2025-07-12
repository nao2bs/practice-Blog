class SiteConfig < ApplicationRecord
  # 例えば、サイト全体で設定が1つしかない場合、シングルトンパターンを考慮することもできますが、
  # まずはシンプルに1レコードだけ作成して利用するのが簡単です。
  # validate :only_one_instance # 必要であれば、インスタンスが1つだけであることを保証するバリデーション
  #
  # private
  # def only_one_instance
  #   if SiteConfig.count > 0 && self.new_record?
  #     errors.add(:base, "You can only have one SiteConfig")
  #   end
  # end
end
