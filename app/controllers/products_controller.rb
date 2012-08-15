class ProductsController < ApplicationController
  before_filter :authorize, :except => [:index, :show, :favorites, :favorite]

  def date_to_datetime(day)
    DateTime.civil(day.year, day.month, day.day, 0, 0, 0, Rational(3,8))
  end

  # GET /products/favorites
  # GET /products/favorites.json
  def favorites
    @products = Product.all
    unless params[:udid].blank?
      if user = User.where(udid: params[:udid]).first
        favorite_ids = user.products.map(&:_id)
        tmp_products = @products
        @products = tmp_products.map do |p|
          if favorite_ids.include?(p._id)
            p[:favorited] = true
            p
          end
        end
        @products.compact!
      end
    end
    
    unless params[:department].blank?
      hospital_ids = Hospital.where(department: params[:department]).map(&:_id)
      tmp_products = Product.where(hospital_id: hospital_ids)
      @products &= tmp_products
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # POST /products/1/favorite
  # POST /products/1/favorite.json
  def favorite
    @product = Product.find(params[:id])

    respond_to do |format|
      if favorited = @product.favorite_toggle(params[:udid])
        format.html { redirect_to @product, notice: 'Favorite was successfully updated.' }
        format.json { render json: {favorite_count: @product.favorite_count, favorited: favorited == 1 ? true : false }, status: :ok }
      else
        format.html { render action: "show" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /products
  # GET /products.json
  def index
    if params[:section].blank?
      @products = Product.all
    else
        today_as_datetime = date_to_datetime(Date.today)
        tommorow_as_datetime = date_to_datetime(Date.today + 1)
      if params[:section] == "today"
        @products = Product.where(event_start_at: today_as_datetime...tommorow_as_datetime)
      # else if params[:section] == "not_today"
      else
        @products = Product.where("products.event_start_at < ?", today_as_datetime)
      end
    end

    unless params[:department].blank?
      hospital_ids = Hospital.where(department: params[:department]).map(&:_id)
      tmp_products = Product.where(hospital_id: hospital_ids)
      @products &= tmp_products
    end

    unless params[:udid].blank?
      if user = User.where(udid: params[:udid]).first
        favorite_ids = user.products.map(&:_id)
        tmp_products = @products
        @products = tmp_products.map do |p|
          if favorite_ids.include?(p._id)
            p[:favorited] = true
            p
          else
            p
          end
        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    unless params[:udid].blank?
      if user = User.where(udid: params[:udid]).first
        favorite_ids = user.products.map(&:_id)
        if favorite_ids.include?(@product._id)
          @product[:favorited] = true
        end
      end
    end

    if @product
      @product.read_count = @product.read_count.nil? ? 0 : @product.read_count + 1
      @product.save
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    @product.photos.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
end