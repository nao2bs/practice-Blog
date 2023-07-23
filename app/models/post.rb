class Post < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "id", "post_name", "updated_at"]
    end
end
