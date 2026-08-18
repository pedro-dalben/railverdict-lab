# frozen_string_literal: true

class CustomersController < ApplicationController
  def index
    @customers = Customer.active
    render json: @customers
  end

  def show
    @customer = Customer.find(params[:id])
    render json: @customer
  end
end
