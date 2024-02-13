class Comment < ApplicationRecord
  belongs_to :post
  has_many :notifications

  # Returns an array of ransackable attributes for the given auth object. If no auth object is provided, it defaults to returning the ransackable attributes for the content, created_at, id, post_id, and updated_at fields.
  def self.ransackable_attributes(_auth_object = nil)
    %w[content created_at id post_id updated_at]
  end

  # Return an array of ransackable associations, which can be used for searching in the notifications and post models.
  def self.ransackable_associations(_auth_object = nil)
    %w[notifications post]
  end

  # private
  # def create_notification
  #   Notification.create(comment: self, content: "New comment on post '#{self.post.title}'")
  # end
end
