class Post < ApplicationRecord
  has_many :comments
  belongs_to :category
  def self.ransackable_attributes(_auth_object = nil)
    %w[author content created_at date id title updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['comments']
  end
end
