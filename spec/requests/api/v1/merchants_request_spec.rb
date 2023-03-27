require "rails_helper"

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it "can get 1 merchant by its id" do
    merchant1 = create(:merchant)

    get "/api/v1/merchants/#{merchant1.id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][:id]).to be_an(String)
    expect(merchant[:data][:id]).to eq(merchant1.id.to_s)
    expect(merchant[:data][:attributes][:name]).to be_an(String)
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
  end

  it "can get all items for a given merchant ID " do
    id = create(:merchant).id
    create_list(:item, 25, merchant_id: id)
    get "/api/v1/merchants/#{id}/items"

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    
    expect(items[:data].count).to eq(25)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)
      
      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_an(String)
      
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end
end