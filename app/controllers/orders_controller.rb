class OrdersController < ApplicationController
  require "net/http"
  before_action :authenticate, except: [:createorder, :get_invoice, :my_orders, :show]

  def index
    @page = params.fetch(:page, 0).to_i || 0
    @orders = Order.all.order(created_at: :desc).offset(@page * 8).limit(8)
    if params.has_key?("today")
      @orders = @orders.in_range(Time.zone.yesterday, Time.zone.now)
    end
    if params.has_key?("user") && params["user"].to_i > 0
      @orders = @orders.with_user(params[:user])
    end
    if params.has_key?("completed")
      @orders = @orders.only_completed
    end
    if params.has_key?("pending")
      @orders = @orders.only_pending
    end
  end

  def show
    @order = Order.find(params[:id])
    @order_items = OrderItem.where("order_id = ?", @order.id)
  end

  def createorder
    if session[:cart]
      order = Order.new({ :user_id => current_user.id, :total => 0, :status => "Pending" })
      tot = 0
      if order.save
        session[:cart].each do |order_item|
          parameter = { :order_id => order.id, :menu_item_id => order_item["dish_id"], :quantity => order_item["quantity"], :total => get_total(order_item) }
          tot = tot + get_total(order_item)
          OrderItem.create!(parameter)
        end
      end
      session[:cart] = nil
      order.total = tot
      order.save
    end
    redirect_to dishes_path
  end

  def mark_as_complete
    @order = Order.find(params[:id])
    @order.status = "Completed"
    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_url, notice: "Order was successfully updated." }
        format.json { head :no_content }
      else
        format.html { redirect_to orders_url, notice: "Something went wrong!" }
        format.json { head :no_content }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def my_orders
    @orders = Order.where("user_id = ?", params[:id])
  end

  def get_invoice
    baseInvoice = {
      "logo" => "https://static.vecteezy.com/system/resources/thumbnails/000/565/921/small/04152019-37.jpg",
      "from" => "The Coffee Shop
  SASTRA Deemed to be University
  Thanjavur, TN 600013",
      "payment_terms" => "Auto-Billed - Do Not Pay",
      "notes" => "Thanks for being an awesome customer!",
      "terms" => "No need to submit payment. You will be auto-billed for this invoice.",
    }
    uri = URI("https://invoice-generator.com")
    to = current_user.name
    order = Order.find(params[:id])
    order_items = OrderItem.where("order_id = ?", order.id)
    items = order_items.map { |item|
      {
        "name" => item.menu_item.name,
        "quantity" => item.quantity,
        "unit_cost" => item.menu_item.price,
      }
    }

    parameter = baseInvoice.merge({
      "to" => to,
      "currency" => "INR",
      "number" => order.id,
      "date" => Time.at(order.created_at).strftime("%b %-d, %Y"),
      "items" => items,
      "fields" => {
        "tax" => false,
      },
      "tax" => 18,
    })
    req = Net::HTTP::Post.new uri
    req["Content-Type"] = "application/json"
    req.body = parameter.to_json

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.request req
    end
    # respond_to do |format|
    #   format.pdf do
    #     send_data res.body, filename: "#{params[:id]}.pdf"
    #   end
    # end
    send_data res.body, filename: "#{params[:id]}.pdf"
  end

  private

  def get_total(order)
    puts order
    order["dish_price"] * order["quantity"]
  end

  def authenticate
    if current_user
      if current_user.role == "User"
        redirect_to root_url
      end
    else
      redirect_to login_path
    end
  end
end
