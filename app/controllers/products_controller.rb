class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    if params[:section].blank?
      @products = Product.all
    else
      if params[:section] == "today"
        @products = Product.where(:event_start_at => Date.today..(Date.today + 1))
      # else if params[:section] == "not_today"
      else
        @products = Product.where(:event_start_at.gte => (Date.today + 1))
      end
    end

    unless params[:department].blank?
      hospital_ids = Hospital.where(department: params[:department]).map(&:_id)
      @products = @products.in(hospital_id: hospital_ids)
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
      @product.inc(:read_count, 1)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # POST /products/1/favorite
  # POST /products/1/favorite.json
  def favorite
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.favorite_toggle(params[:udid])
        format.html { redirect_to @product, notice: 'Favorite was successfully updated.' }
        format.json { render json: @product.favorite_count, status: :ok }
      else
        format.html { render action: "show" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

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