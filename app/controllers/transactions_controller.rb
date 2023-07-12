# frozen_string_literal: true

# Display transactions
class TransactionsController < ApplicationController
  before_action :authenticate_merchant!

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all.order(created_at: :desc).preload(:merchant, :transactions, :parent_transaction)
    # admins can see all transactions, merchants their own only
    unless current_merchant.admin?
      @merchant = current_merchant
      @transactions = @transactions.where(merchant_id: @merchant.id)
    end
    if params[:merchant_id].present?
      @merchant = Merchant.find_by(id: params[:merchant_id])
      if @merchant
        @transactions = @transactions.where(merchant_id: @merchant.id)
      end
    end
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
