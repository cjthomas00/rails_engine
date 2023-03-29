class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name, presence: true

  def self.search_by_name(criteria)
    where("name ILIKE ?", "%#{criteria}%").order(:name)
  end
end
