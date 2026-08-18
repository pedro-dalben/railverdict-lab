# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :active, -> { where(status: "active") }

  def vip?
    orders.where(status: "completed").count >= 5
  end
end
