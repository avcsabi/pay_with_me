# frozen_string_literal: true

# Display transactions
class TransactionsController < ApplicationController
  before_action :authenticate_merchant!
  load_and_authorize_resource

  # GET /transactions or /transactions.json
  def index
    # Admins can see all transactions, merchants their own only
    @transactions = Transaction.filter_non_admin(current_merchant).sort_and_preload
    @merchant = current_merchant unless current_merchant.admin?
    if params[:merchant_id].present?
      # Admins can filter transactions to a certain merchant. For non-admin this will have no effect
      @merchant = Merchant.find(params[:merchant_id])
      @transactions = @transactions.where(merchant_id: @merchant)
    end
    # Will load only a page of 50 transactions, not all
    @transactions = @transactions.paginate(page: params[:page], per_page: 50)
  end

  # GET /transactions/1 or /transactions/1.json
  def show
    @transaction = if current_merchant.admin?
                     Transaction.find_by(id: params[:id])
                   else
                     current_merchant.transactions.find_by(id: params[:id])
                   end
    return if @transaction

    redirect_back fallback_location: transactions_path, alert: 'Transaction not found'
  end
end
