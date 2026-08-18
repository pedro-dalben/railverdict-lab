# frozen_string_literal: true

require_relative "../test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @customer = Customer.create!(name: "Controller Cust", email: "ctrl@orderhub.test")
    @order = Order.create!(customer: @customer, order_number: "ORD-9999", total_amount: 99.00)
  end

  def test_index_orders
    get orders_path
    assert_response :success
    assert_includes response.body, "Order Management"
    assert_includes response.body, "ORD-9999"
  end

  def test_show_order
    get order_path(@order)
    assert_response :success
    assert_includes response.body, "ORD-9999"
    assert_includes response.body, "Controller Cust"
  end
end
