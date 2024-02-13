class Notification < ApplicationRecord
  belongs_to :user

  def comment=(value)
    # comment属性を設定する処理を記述
  end

  # A method to determine the ransackable attributes with an optional authentication object parameter.
  def self.ransackable_attributes(_auth_object = nil)
    %w[comment_id content created_at id read updated_at user_id]
  end
end
