class Api::V1::Merchant::SearchController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.search_by_name(params[:name]))
  end
end