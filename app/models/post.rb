class Post < ApplicationRecord

    def self.ransackable_attributes(auth_object = nil)
        ["author", "content", "created_at", "date", "id", "title", "updated_at"]
    end
    
end
