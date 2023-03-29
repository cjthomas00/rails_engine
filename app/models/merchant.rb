class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name, presence: true

  def self.search_by_name(criteria)
    require 'pry'; binding.pry
  end
end
