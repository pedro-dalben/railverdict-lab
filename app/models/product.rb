# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, presence: true
  validates :sku, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :in_stock, -> { where("stock_quantity > 0") }

  def available?
    stock_quantity.positive?
  end

  def decrement_stock!(amount = 1)
    raise ArgumentError, "Insufficient stock" if stock_quantity < amount

    update!(stock_quantity: stock_quantity - amount)
  end
end
