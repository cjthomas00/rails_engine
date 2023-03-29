class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name, presence: true, format: { with: /\A(?!^\d+$).*\z/m }
  validates :description, presence: true, format: { with: /\A[a-zA-Z\s,.;?!]+\z/ } 
  validates :unit_price, presence: true, numericality: { is_greater_than_or_equal_to: 0, only_float: true, message: "is not valid. Must be greater than 0, and be a valid float" }
end