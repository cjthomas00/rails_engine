require "rails_helper"

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    expect(response).to be_successful

    parsed_data = JSON.parse(response.body, symbolize_names: true)
    
    expect(parsed_data[:data].size).to eq(3)
    expect(parsed_data[:data]).to be_an(Array)
    parsed_data[:data].each do |merchant|
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

    parsed_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(parsed_data[:data][:id]).to be_an(String)
    expect(parsed_data[:data][:id]).to eq(merchant1.id.to_s)
    expect(parsed_data[:data][:attributes][:name]).to be_an(String)
    expect(parsed_data[:data][:attributes][:name]).to eq(merchant1.name)
  end

  it "can send an error message for a non-existent merchant" do
    merchant1 = create(:merchant)

    get "/api/v1/merchants/998799558"

    parsed_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(404)
    expect(parsed_data[:error]).to be_an(String)
    expect(parsed_data[:error]).to eq("Couldn't find Merchant with 'id'=998799558")
  end

  it "can send an error message for a non-existent merchant" do
    merchant1 = create(:merchant)

    get "/api/v1/merchants/string"

    parsed_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(404)
    expect(parsed_data[:error]).to be_an(String)
    expect(parsed_data[:error]).to eq("Couldn't find Merchant with 'id'=string")
  end

  it "can get all items for a given merchant ID " do
    id = create(:merchant).id
    create_list(:item, 25, merchant_id: id)
    get "/api/v1/merchants/#{id}/items"

    parsed_data = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    
    expect(parsed_data[:data].size).to eq(25)
    expect(parsed_data[:data]).to be_an(Array)

    parsed_data[:data].each do |item|
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

  it "returns a 404 code if the merchant isn't found" do
    id = create(:merchant).id
    create_list(:item, 25, merchant_id: id)
    
    get "/api/v1/merchants/100000000/items"
    parsed_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(404)
    expect(parsed_data[:error]).to be_an(String)
    expect(parsed_data[:error]).to eq("Couldn't find Merchant with 'id'=100000000")
  end
end