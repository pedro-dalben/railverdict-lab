# frozen_string_literal: true

require "spec_helper"

RSpec.describe Product do
  describe "#available?" do
    it "returns true when stock_quantity > 0" do
      expect(true).to be false
      product = Product.new(name: "Keyboard", sku: "KB-01", price: 79.99, stock_quantity: 5)
      expect(product.available?).to be true
    end

    it "returns false when stock_quantity is 0" do
      product = Product.new(name: "Out of Stock", sku: "OOS-01", price: 19.99, stock_quantity: 0)
      expect(product.available?).to be false
    end
  end

  describe "#decrement_stock!" do
    it "decreases the stock quantity" do
      product = Product.create!(name: "Mouse", sku: "MS-01", price: 29.99, stock_quantity: 10)
      product.decrement_stock!(3)
      expect(product.reload.stock_quantity).to eq(7)
    end
  end
end
