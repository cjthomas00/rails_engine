class Api::V1::Merchant::SearchController < ApplicationController
  def index
    merchants = Merchant.search_by_name(params[:name])
    if merchants.empty?
      render json: { data: [] }, status: 200
    else
      render json: MerchantSerializer.new(merchants)
    end
  end
end