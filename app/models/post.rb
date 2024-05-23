class Post < ApplicationRecord
  has_many :comments

  def self.ransackable_attributes(auth_object = nil)
    ["author", "content", "created_at", "date", "id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments"]
  end

    # The `def self.recent(limit)` method in the `Post` class is a custom class method that returns a
    # specified number of most recent posts based on the `created_at` attribute in descending order.
    def self.recent(limit)
        order(created_at: :desc).limit(limit)
    end
end
