# frozen_string_literal: true

require_relative "../test_helper"

class CustomerTest < ActiveSupport::TestCase
  def setup
    @customer = Customer.create!(name: "Acme Corp", email: "contact@acme.test", status: "active")
  end

  def test_valid_customer
    assert @customer.valid?
  end

  def test_email_validation
    invalid_customer = Customer.new(name: "Invalid", email: "not-an-email")
    assert_not invalid_customer.valid?
    assert_includes invalid_customer.errors[:email], "is invalid"
  end

  def test_active_scope
    Customer.create!(name: "Inactive Corp", email: "inactive@acme.test", status: "inactive")
    assert_includes Customer.active, @customer
  end
end
