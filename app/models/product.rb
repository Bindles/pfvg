class Product < ApplicationRecord
    validates :entity_id, presence: true
end
