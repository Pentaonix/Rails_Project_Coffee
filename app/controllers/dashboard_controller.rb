class DashboardController < ApplicationController
  before_action :authenticate

  def dash
    # dish_menu = OrderItem.group(:menu_item_id).count
    # menu_name = MenuItem.where("menu_id = ?", 2).pluck_to_hash(:id, :name)  ##{pass params from erb for menu_id}
    # menu_hash = {}
    # menu_name.each do |menu_item|
    #   menu_hash[menu_item["id"]] = menu_item["name"]
    # end
    # @dish_count = {}
    # dish_menu.each do |dish|
    #   @dish_count[menu_hash[dish.first]] = dish.second if menu_hash[dish.first]
    # end
    @menu = Menu.all.pluck_to_hash(:id)
    @active_menu = Menu.where("active=?", true).pluck_to_hash(:name)[0]
    results_with_count = ActiveRecord::Base.connection.execute("select menu_items.name,count(*) FROM menu_items INNER JOIN order_items ON menu_items.id=order_items.menu_item_id WHERE menu_items.menu_id=#{params[:id] || 1}  GROUP BY menu_items.id")  ##{pass params from erb for menu_id}
    @dish_and_count = {}
    results_with_count.each { |res| @dish_and_count[res["name"]] = res["count"] }

    results_with_price = ActiveRecord::Base.connection.execute("select menu_items.name,count(*),menu_items.price FROM menu_items INNER JOIN order_items ON menu_items.id=order_items.menu_item_id WHERE menu_items.menu_id=#{params[:id] || 1}  GROUP BY menu_items.id")
    # {pass params from erb for menu_id}
    @dish_and_amount = {}
    results_with_price.each { |res| @dish_and_amount[res["name"]] = (res["count"] * res["price"]) }

    revenue = ActiveRecord::Base.connection.execute("select date(updated_at),total FROM orders WHERE status ='Completed' ")
    @revenue_daily = {}
    revenue.each { |res| @revenue_daily[res["date"]] = res["total"] }

    @completed_and_pending = Order.group(:status).count
  end

  def menu_dash
  end

  def authenticate
    if current_user
      if current_user.role != "Admin"
        redirect_to root_url
      end
    else
      redirect_to login_path
    end
  end
end
