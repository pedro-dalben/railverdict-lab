# frozen_string_literal: true

class OrderNotificationJob < ApplicationJob
  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order

    LegacyAuditLogger.log("order_notification_sent", order_id: order.id, customer_id: order.customer_id)
    true
  end
end
