# frozen_string_literal: true

# Base class for controllers
class ApplicationController < ActionController::Base
  respond_to :html

  def current_ability
    @current_ability ||= ::Ability.new(current_merchant)
  end
end
