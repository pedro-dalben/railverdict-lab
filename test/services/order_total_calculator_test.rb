# frozen_string_literal: true

require_relative "../test_helper"

class OrderTotalCalculatorTest < ActiveSupport::TestCase
  def test_subtotal_calculation
    items = [
      { price: 10.0, quantity: 2 },
      { price: 15.0, quantity: 1 }
    ]
    calc = OrderTotalCalculator.new(items)
    assert_equal 35.0, calc.subtotal
  end

  def test_discount_calculation
    items = [{ price: 100.0, quantity: 1 }]
    calc = OrderTotalCalculator.new(items, discount_code: "SAVE10")
    assert_equal 10.0, calc.discount_amount
  end

  def test_total_with_tax
    items = [{ price: 100.0, quantity: 1 }]
    total = OrderTotalCalculator.calculate(items)
    assert_equal 108.0, total
  end
end
