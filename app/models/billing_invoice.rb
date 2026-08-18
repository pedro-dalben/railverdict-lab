# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :order

  validates :invoice_number, presence: true, uniqueness: true
  validates :amount_due, numericality: { greater_than_or_equal_to: 0 }

  scope :unpaid, -> { where(payment_status: "unpaid") }
  scope :paid, -> { where(payment_status: "paid") }

  def mark_as_paid!
    update!(payment_status: "paid")
  end
end
