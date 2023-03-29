require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end

  describe "instance methods" do
    it "#has_multiple_items?" do
      merchant = create(:merchant)
      customer = create(:customer)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)
      invoice1 = create(:invoice, customer: customer, merchant: merchant)
      invoice2 = create(:invoice, customer: customer, merchant: merchant)
      invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1)
      invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2)
      invoice_item3 = create(:invoice_item, invoice: invoice2, item: item1)

      expect(invoice1.has_multiple_items?).to eq(true)
      expect(invoice2.has_multiple_items?).to eq(false)
      expect(invoice1.items.size).to eq(2)
      expect(invoice2.items.size).to eq(1)
    end
  end
end