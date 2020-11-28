class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy]
  before_action :authenticate
  # GET /menus
  # GET /menus.json
  def index
    @menus = Menu.all
    @menu = Menu.new
    @active = Menu.where("active = ?", true)
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
    @dishes = MenuItem.where("menu_id = ?", params[:id])
  end

  # GET /menus/new
  def new
    @menu = Menu.new
  end

  def activate
    already_active_menu = Menu.where("active = ?", true).limit(1)

    if already_active_menu.length > 0
      already_active_menu[0].active = false
      already_active_menu[0].save
    end
    menu = Menu.find(params[:menu_id])
    menu.active = !(menu.active)
    menu.save
    respond_to do |format|
      format.html { redirect_to menus_url, notice: "Menu was successfully updated." }
    end
  end

  # GET /menus/1/edit
  def edit
    @dishes = MenuItem.where("menu_id = ?", params[:id])
  end

  # POST /menus
  # POST /menus.json
  def create
    @menu = Menu.new(menu_params)

    respond_to do |format|
      if @menu.save
        if Menu.count() == 1
          @menu.active = true
          @menu.save
        end
        format.html { redirect_to menus_url, notice: { :message => "Menu was successfully created." } }
        format.json { render :show, status: :created, location: @menu }
      else
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.html { redirect_to @menu, notice: "Menu was successfully updated." }
        format.json { render :show, status: :ok, location: @menu }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to menus_url, notice: "Menu was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu
    @menu = Menu.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def menu_params
    params.require(:menu).permit(:name, :image, :active)
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
