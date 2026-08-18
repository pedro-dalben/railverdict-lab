# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @orders = Order.all.order(created_at: :desc)
    render :index
  end

  def show
    @order = Order.find(params[:id])
    render :show
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      OrderNotificationJob.perform_later(@order.id)
      render json: @order, status: :created
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :order_number, :total_amount, :status)
  end
end
