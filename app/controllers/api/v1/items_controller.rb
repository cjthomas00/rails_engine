class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(Item.create!(item_params)), status: :created
    else
      render json: { errors: "Invalid Item Creation, 1 or more fields is missing or incorrect" }, status: :bad_request
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else 
      render json: { errors: "Invalid Update, 1 or more fields is missing or incorrect" }, status: :bad_request
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end