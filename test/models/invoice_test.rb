# frozen_string_literal: true

require_relative "../test_helper"

class InvoiceTest < ActiveSupport::TestCase
  def setup
    customer = Customer.create!(name: "Invoice Customer", email: "inv@orderhub.test")
    @order = Order.create!(customer: customer, order_number: "ORD-2001", total_amount: 200.00)
    @invoice = Invoice.create!(order: @order, invoice_number: "INV-2001", amount_due: 200.00, payment_status: "unpaid")
  end

  def test_valid_invoice
    assert @invoice.valid?
  end

  def test_mark_as_paid
    @invoice.mark_as_paid!
    assert_equal "paid", @invoice.payment_status
  end

  def test_unpaid_scope
    assert_includes Invoice.unpaid, @invoice
  end
end
