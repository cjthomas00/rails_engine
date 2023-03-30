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
      render json: ErrorSerializer.new("Invalid Item Creation, 1 or more fields is missing or incorrect", 400).invalid_entry , status: :bad_request
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else 
      render json: ErrorSerializer.new("Invalid Update, 1 or more fields is missing or incorrect", 400).invalid_entry, status: :bad_request
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.invoices.each do |invoice|
      if invoice.has_multiple_items?
        invoice_item = invoice.invoice_items.find_by(item_id: item.id)
        invoice_item.destroy
      else
        invoice.destroy
      end
    end
    render json: Item.delete(params[:id]), status: :no_content
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end