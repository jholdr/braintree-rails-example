class CreditCardsController < ApplicationController
  before_filter :find_user, :find_customer
  before_filter :find_credit_card, :except => [:new, :create]

  def index
    @credit_cards = @customer.credit_cards
  end

  def new
    billing_address = @customer.addresses.first || {}
    @credit_card = @customer.credit_cards.build({:cardholder_name => @customer.full_name, :billing_address => billing_address})
  end

  def create
    @credit_card = @customer.credit_cards.build(params[:credit_card])
    if @credit_card.save
      flash[:notice] = "Credit card has been successfully updated."
      redirect_to user_customer_credit_card_path(@user, @credit_card.id)
    else
      render :new
    end
  end

  def update
    if @credit_card.update_attributes(params[:credit_card])
      flash[:notice] = "Credit card has been successfully updated."
      redirect_to user_customer_credit_card_path(@user, @credit_card.id) and return
    else
      render :edit
    end
  end

  def destroy
    @credit_card.destroy
    flash[:notice] = "Credit card has been successfully deleted."
    redirect_to user_customer_credit_cards_path(@user)
  end

  protected
  def find_user
    @user = User.find(params[:user_id])
  end

  def find_customer
    @customer = BraintreeRails::Customer.find(@user.customer_id) if @user.customer_id.present?
    redirect_to user_path(@user) and return if @customer.nil?
  end

  def find_credit_card
    @credit_card = @customer.credit_cards.find(params[:id])
  end
end
