class Post < ApplicationRecord
    has_many :comments

    def self.ransackable_attributes(auth_object = nil)
        ["author", "content", "created_at", "date", "id", "title", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["comments"]
      end
end
