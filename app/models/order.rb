# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :customer
  has_one :invoice, dependent: :destroy

  validates :order_number, presence: true, uniqueness: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where(status: "completed") }

  def mark_as_completed!
    update!(status: "completed")
  end

  def can_cancel?
    status == "pending"
  end

  def expired_waiver_calc
    unused_expired_var = 456
  end
end
