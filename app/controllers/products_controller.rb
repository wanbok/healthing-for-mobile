class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    if params[:section].blank?
      @products = Product.all
    else
      if params[:section] == "today"
        @products = Product.where(:event_start_at.lt => (Date.today + 1))
      # else if params[:section] == "not_today"
      else
        @products = Product.where(:event_start_at.gte => (Date.today + 1))
      end
    end

    unless params[:department].blank?
      hospital_ids = Hospital.where(department: params[:department]).map(&:_id)
      @products = @products.in(hospital_id: hospital_ids)
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
    if @product
      @product.inc(:read_count, 1)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # POST /products/1
  # POST /products/1.json
  def favorite
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.favorite(params[:udid])
        format.html { redirect_to @product, notice: 'Favorite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
