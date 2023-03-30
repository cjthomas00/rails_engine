class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  
  validates_presence_of :name, presence: true, format: { with: /\A(?!^\d+$).*\z/m }
  validates :description, presence: true, format: { with: /\A[a-zA-Z\s,.;?!]+\z/ } 
  validates :unit_price, presence: true, numericality: { is_greater_than_or_equal_to: 0, only_float: true, message: "is not valid. Must be greater than 0, and be a valid float" }

  def self.find_one_by_name(criteria)
    where("name ILIKE ?", "%#{criteria}%").order(:name).first
  end
end