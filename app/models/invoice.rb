class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  
  belongs_to :merchant
  belongs_to :customer

  def has_multiple_items?
    items.size > 1
  end
end