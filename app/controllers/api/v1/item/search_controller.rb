class Api::V1::Item::SearchController < ApplicationController
  def show
    if params[:name] && (params[:min_price] || params[:max_price])
      render json: ErrorSerializer.new("Invalid Search Parameters", 400).invalid_entry, status: 400
    elsif params[:name]
      name_search
    else params[:min_price] || params[:max_price]
      price_search
    end
  end


  private

  def name_search
    if Item.find_one_by_name(params[:name]) == nil
        render json: { data: {} }, status: 200 
    else 
      render json: ItemSerializer.new(Item.find_one_by_name(params[:name]))
    end
  end
 
  def price_search 
    if (params[:min_price].to_f < 0 || params[:max_price].to_f < 0)
      render json: ErrorSerializer.new("Invalid Search Parameters", 400).invalid_entry, status: 400
    else 
      item = Item.search_by_price(params[:min_price], params[:max_price])
      if item.nil?
        render json: { data: {} }, status: 200 
      else 
        render json: ItemSerializer.new(item)
      end
    end
  end
end