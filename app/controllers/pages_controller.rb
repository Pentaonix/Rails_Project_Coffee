class PagesController < ApplicationController
  before_action :initialize_session

  def index
  end

  def dishes
    @menu = Menu.where("active = ?", true)[0]
    if @menu
      @dishes = MenuItem.where("menu_id = ?", @menu.id)
      @cart = session[:cart]
      @total = 0
      session[:cart].each do |o|
        @total = @total + o["dish_price"] * o["quantity"]
      end
    else
      @dishes = nil
      @cart = nil
    end
  end

  def add_to_cart
    update_cart(params[:dish_id].to_i, params[:quantity].to_i, params[:dish_name], params[:dish_price].to_f)
    redirect_to(action: "dishes")
  end

  def remove_from_cart
    paramId = params["format"].to_i
    session[:cart].select! { |dish| dish["dish_id"] != paramId }
    redirect_to(action: "dishes")
  end

  private

  def initialize_session
    session[:cart] ||= []
  end

  def update_cart(dish_id, quantity, dish_name, dish_price)
    order = {}
    order[:dish_id] = dish_id
    order[:dish_name] = dish_name
    order[:dish_price] = dish_price
    order[:quantity] = quantity.to_i
    session[:cart] << order
  end
end
