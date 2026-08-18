# frozen_string_literal: true

class OrderPolicy
  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end

  def show?
    user.present? && (user_is_admin? || customer_matches?)
  end

  def update?
    user.present? && (user_is_admin? || (customer_matches? && order.can_cancel?))
  end

  def destroy?
    user_is_admin?
  end

  private

  def user_is_admin?
    user&.dig(:role) == "admin"
  end

  def customer_matches?
    order.customer_id == user&.dig(:customer_id)
  end
end
