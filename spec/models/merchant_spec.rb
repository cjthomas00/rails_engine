require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
  end

  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "class methods" do
    it "can #search_by_name" do
    store1 = create(:merchant, name: "Scarlett's store")
    store2 = create(:merchant, name: "Caleb's store")
    store3 = create(:merchant, name: "Joslyns's store")

    expect(Merchant.search_by_name("store")).to eq([store2, store3, store1])
    expect(Merchant.search_by_name("le")).to eq([store2, store1])
    expect(Merchant.search_by_name("J")).to eq([store3])
    expect(Merchant.search_by_name("J")).to_not eq([store1, store2])
    end
  end
end
