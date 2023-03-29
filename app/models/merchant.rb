class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices, dependent: :destroy

  validates_presence_of :name, presence: true

  def self.search_by_name(criteria)
    where("name ILIKE ?", "%#{criteria}%").order(:name)
  end
end
