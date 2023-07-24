class Comment < ApplicationRecord
  belongs_to :post

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "post_id", "updated_at"]
  end
end
