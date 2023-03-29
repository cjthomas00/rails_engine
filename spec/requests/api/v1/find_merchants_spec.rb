require "rails_helper"

RSpec.describe "Find_merchants" do
  describe "Find all merchants that match a search term" do
    it "can find all merchants that match search criteria" do
      create(:merchant, name: "Zee's Tavern")
      create(:merchant, name: "Arts's Habidashery")
      create(:merchant, name: "Mega-lo Mart")

      get "/api/v1/merchants/find_all?name=mart"

      expect(response).to be_successful
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      
      expect(parsed_data[:data]).to be_a(Array)
      expect(parsed_data[:data].size).to eq(1)
      parsed_data[:data].each do |data|
        expect(data).to have_key(:id)
        expect(data[:id]).to be_an(String)
        expect(data).to have_key(:type)
        expect(data[:type]).to be_an(String)
        expect(data[:type]).to eq("merchant")
        expect(data[:attributes]).to have_key(:name)
        expect(data[:attributes][:name]).to be_an(String)
        expect(data[:attributes][:name]).to eq("Mega-lo Mart")
      end
    end
  end
end