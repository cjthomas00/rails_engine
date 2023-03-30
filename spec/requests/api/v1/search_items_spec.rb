require "rails_helper"

RSpec.describe "SearchItems", type: :request do
  describe "Find a Single Item" do
    it "can find a single item that matches search criteria" do
      create(:item, name: "Zebra striped socks")
      create(:item, name: "Brown socks")
      create(:item, name: "Mermaid tail socks")

      get "/api/v1/items/find?name=socks"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      parsed_data = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_data[:data]).to be_a(Hash)
      expect(parsed_data[:data]).to have_key(:id)
      expect(parsed_data[:data][:id]).to be_an(String)
      expect(parsed_data[:data]).to have_key(:type)
      expect(parsed_data[:data][:type]).to be_an(String)
      expect(parsed_data[:data][:type]).to eq("item")
      expect(parsed_data[:data][:attributes]).to have_key(:name)
      expect(parsed_data[:data][:attributes][:name]).to be_an(String)
      expect(parsed_data[:data][:attributes][:name]).to eq("Brown socks")
      expect(parsed_data[:data][:attributes][:name]).to_not eq("Zebra striped socks")
      expect(parsed_data[:data][:attributes][:name]).to_not eq("Mermaid tail socks")
    end

    it "returns an error message if no records are found" do
      create(:item, name: "Zebra striped socks")
      create(:item, name: "Brown socks")
      create(:item, name: "Mermaid tail socks")

      get "/api/v1/items/find?name=house"
  
      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_data[:errors]).to eq("Item not found")
    end

    it "can return a single item by minimum price" do
      create(:item, name: "Zebra striped socks", unit_price: 99.99)
      create(:item, name: "Brown socks", unit_price: 199.99)
      create(:item, name: "Mermaid tail socks", unit_price: 299.99)

      get "/api/v1/items/find?min_price=199"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_data[:data][:attributes][:name]).to eq("Brown socks")
    end
  end
end