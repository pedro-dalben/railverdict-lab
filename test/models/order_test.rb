# frozen_string_literal: true

require_relative "../test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @customer = Customer.create!(name: "Test Customer", email: "cust@orderhub.test")
    @order = Order.create!(customer: @customer, order_number: "ORD-1001", total_amount: 150.00, status: "pending")
  end

  def test_valid_order
    assert @order.valid?
  end

  def test_can_cancel_when_pending
    assert @order.can_cancel?
  end

  def test_mark_as_completed
    @order.mark_as_completed!
    assert_equal "completed", @order.status
    assert_not @order.can_cancel?
  end

  def test_order_number_uniqueness
    duplicate = Order.new(customer: @customer, order_number: "ORD-1001", total_amount: 50.00)
    assert_not duplicate.valid?
  end
end
