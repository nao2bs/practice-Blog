class Comment < ApplicationRecord
  belongs_to :post

  validates :content, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[content created_at id post_id updated_at]
  end
end
