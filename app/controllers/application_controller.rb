# frozen_string_literal: true

# ------------------------------------------------
class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { head :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
