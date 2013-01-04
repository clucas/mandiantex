class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_currency
  
  def set_currency 
    @currency = params[:currency] || "USD"
  end
  
end
