class Api::V1::Item::SearchController < ApplicationController
  def show
    # require 'pry'; binding.pry
    by_name if params[:name]
    if by_name == nil
      render json: { errors: "Item not found" }, status: :bad_request
    else 
      render json: ItemSerializer.new(by_name)
    end
  end

  private

  def by_name
    Item.find_one_by_name(params[:name])
  end

  def min_price
    Item.find_by_min_price(params[:min_price])
  end

  def max_price
    Item.find_by_max_price(params[:max_price])
  end
end