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

    it "returns an empty hash if no records are found" do
      create(:item, name: "Zebra striped socks")
      create(:item, name: "Brown socks")
      create(:item, name: "Mermaid tail socks")

      get "/api/v1/items/find?name=house"
  
      expect(response).to be_successful
      expect(response).to have_http_status(200)

      parsed_data = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_data).to be_a(Hash)
      expect(parsed_data[:data]).to be_empty
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

    it "can find an item by maximum price" do
      create(:item, name: "Zebra striped socks", unit_price: 99.99)
      create(:item, name: "Brown socks", unit_price: 199.99)
      create(:item, name: "Mermaid tail socks", unit_price: 299.99)

      get "/api/v1/items/find?max_price=199"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_data[:data][:attributes][:name]).to eq("Zebra striped socks")
    end

    it "can find an item by minimum and maximum price" do
      create(:item, name: "Zebra striped socks", unit_price: 99.99)
      create(:item, name: "Brown socks", unit_price: 199.99)
      create(:item, name: "Mermaid tail socks", unit_price: 299.99)

      get "/api/v1/items/find?min_price=299&max_price=399"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_data[:data][:attributes][:name]).to eq("Mermaid tail socks")
    end

    it "wont find an item if the min and max price are out of range and return empty hash" do
      create(:item, name: "Zebra striped socks", unit_price: 99.99)
      create(:item, name: "Brown socks", unit_price: 199.99)
      create(:item, name: "Mermaid tail socks", unit_price: 299.99)

      get "/api/v1/items/find?min_price=399&max_price=499"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_data).to be_a(Hash)
      expect(parsed_data[:data]).to be_empty
    end

    it "wont return an item if the either price is less than 0" do
      create(:item, name: "Zebra striped socks", unit_price: 99.99)
      create(:item, name: "Brown socks", unit_price: 199.99)
      create(:item, name: "Mermaid tail socks", unit_price: 299.99)

      get "/api/v1/items/find?min_price=-1"

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      parsed_data[:errors].each do |error|
        expect(error[:status]).to eq("400")
        expect(error[:title]).to eq("Invalid Search Parameters")
      end

      get "/api/v1/items/find?max_price=-1"

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      parsed_data[:errors].each do |error|
        expect(error[:status]).to eq("400")
        expect(error[:title]).to eq("Invalid Search Parameters")
      end
    end

    it "wont return an item if searched by name and price" do
      create(:item, name: "Zebra striped socks", unit_price: 99.99)
      create(:item, name: "Brown socks", unit_price: 199.99)
      create(:item, name: "Mermaid tail socks", unit_price: 299.99)

      get "/api/v1/items/find?min_price=299&name=socks"

      
      expect(response).to have_http_status(400)
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      parsed_data[:errors].each do |error|
        expect(error[:status]).to eq("400") 
        expect(error[:title]).to eq("Invalid Search Parameters") 
      end
    end
  end
end