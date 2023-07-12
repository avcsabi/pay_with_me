# frozen_string_literal: true

# Display, edit, destroy merchants
class MerchantsController < ApplicationController
  before_action :authenticate_merchant!
  before_action :set_merchant, only: %i[show edit update destroy]

  # GET /merchants or /merchants.json
  def index
    @merchants = Merchant.all.order('LOWER(name)').order(created_at: :desc)
                         .paginate(page: params[:page], per_page: 50)
  end

  # GET /merchants/1 or /merchants/1.json
  def show; end

  # GET /merchants/new
  def new
    @merchant = Merchant.new
  end

  # GET /merchants/1/edit
  def edit; end

  # POST /merchants or /merchants.json
  def create
    @merchant = Merchant.new(merchant_params)

    respond_to do |format|
      if @merchant.save
        format.html { redirect_to merchant_url(@merchant), notice: 'Merchant was successfully created.' }
        format.json { render :show, status: :created, location: @merchant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @merchant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /merchants/1 or /merchants/1.json
  def update
    respond_to do |format|
      if @merchant.update(merchant_params)
        format.html { redirect_to merchant_url(@merchant), notice: 'Merchant was successfully updated.' }
        format.json { render :show, status: :ok, location: @merchant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @merchant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /merchants/1 or /merchants/1.json
  def destroy
    if @merchant.transactions.count > 0
      error = 'Merchant cannot be deleted because it has transactions'
      respond_to do |format|
        format.html { redirect_to merchants_url, alert: error }
        format.json { render json: { error: error }, status: :unprocessable_entity }
      end
      return
    end
    if @merchant.destroy
      respond_to do |format|
        format.html { redirect_to merchants_url, notice: 'Merchant was successfully deleted' }
        format.json { head :no_content }
      end
    else
      error = 'Error deleting merchant'
      respond_to do |format|
        format.html { redirect_to merchants_url, alert: error }
        format.json { render json: { error: error }, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_merchant
    @merchant = Merchant.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def merchant_params
    params.require(:merchant).permit(:name, :description, :email, :admin, :password, :password_confirmation)
  end
end
