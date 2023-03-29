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
      require 'pry'; binding.pry
    end
  end
end