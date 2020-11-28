class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  def self.in_range(time1, time2)
    where("created_at <= ? AND created_at >= ?", time2, time1)
  end
  def self.created_before(time)
    where("created_at < ?", time)
  end

  def self.with_user(id)
    where("user_id = ?", id)
  end

  def self.only_pending
    where("status = 'Pending'")
  end

  def self.only_completed
    where("status = 'Completed'")
  end
end
