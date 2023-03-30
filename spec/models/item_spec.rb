require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_numericality_of(:unit_price).with_message("is not valid. Must be greater than 0, and be a valid float") }
    it { should validate_presence_of :unit_price }
  end

  describe "class methods" do
    it "can find one item by search criteria in alphabetical order" do
      item1 = create(:item, name: "Zebra striped socks")
      item2 = create(:item, name: "Brown  socks")
      item3 = create(:item, name: "Mermaid tail striped socks")

      expect(Item.find_one_by_name("socks")).to eq(item2)
      expect(Item.find_one_by_name("striped")).to eq(item3)
    end
  end
end