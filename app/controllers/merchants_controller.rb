# frozen_string_literal: true

# Display, edit, destroy merchants
class MerchantsController < ApplicationController
  before_action :authenticate_merchant!
  before_action :set_merchant, only: %i[show edit update destroy]
  load_and_authorize_resource

  # GET /merchants or /merchants.json
  def index
    @merchants = Merchant.filter_non_admin(current_merchant).order('LOWER(name)').order(created_at: :desc)
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
    flash[:notice] = 'Merchant was successfully created.' if @merchant.save
    respond_with @merchant
  end

  # PATCH/PUT /merchants/1 or /merchants/1.json
  def update
    flash[:notice] = 'Merchant was successfully updated.' if @merchant.update(merchant_params)
    respond_with @merchant
  end

  # DELETE /merchants/1 or /merchants/1.json
  def destroy
    respond_to do |format|
      if @merchant.destroy
        format.html { redirect_to merchants_url, notice: 'Merchant was successfully deleted' }
        format.json { head :no_content }
      else
        error = @merchant.errors.full_messages.join('; ').presence || 'Error deleting merchant'
        format.html { redirect_to merchants_url, alert: error }
        format.json { render json: { error: }, status: :unprocessable_entity }
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
