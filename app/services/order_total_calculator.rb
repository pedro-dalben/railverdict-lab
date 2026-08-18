# frozen_string_literal: true

class OrderTotalCalculator
  TAX_RATE = 0.08

  def self.calculate(items, discount_code: nil)
    new(items, discount_code: discount_code).total
  end

  def initialize(items, discount_code: nil)
    @items = items || []
    @discount_code = discount_code
  end

  def subtotal
    @items.sum { |item| (item[:price] || 0) * (item[:quantity] || 1) }
  end

  def discount_amount
    case @discount_code
    when "SAVE10"
      subtotal * 0.10
    when "SAVE20"
      subtotal * 0.20
    else
      0.0
    end
  end

  def tax_amount
    (subtotal - discount_amount) * TAX_RATE
  end

  def total
    (subtotal - discount_amount + tax_amount).round(2)
  end
end
