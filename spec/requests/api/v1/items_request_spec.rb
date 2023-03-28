require "rails_helper"

describe "Items API" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 25, merchant_id: merchant.id)

    get "/api/v1/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

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

  it "gets one item" do 
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item1.id}"

    item = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    
    expect(item[:data][:id]).to be_an(String)
    expect(item[:data][:id]).to eq(item1.id.to_s)
    expect(item[:data][:attributes][:name]).to be_an(String)
    expect(item[:data][:attributes][:name]).to eq(item1.name)
    expect(item[:data][:attributes][:description]).to be_an(String)
    expect(item[:data][:attributes][:description]).to eq(item1.description)
    expect(item[:data][:attributes][:unit_price]).to be_an(Float)
    expect(item[:data][:attributes][:unit_price]).to eq(item1.unit_price)
    expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    expect(item[:data][:attributes][:merchant_id]).to eq(item1.merchant_id)
  end

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = ({
    name: "new thing", 
    description: "best new thing ever.", 
    unit_price: 96.37, 
    merchant_id: merchant.id})

    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to have_http_status(201)
    
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end
end