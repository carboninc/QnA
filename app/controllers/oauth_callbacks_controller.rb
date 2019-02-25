# frozen_string_literal: true

# ------------------------------------------------
class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def github
    log_in_with('Github')
  end

  def vkontakte
    log_in_with('VK')
  end

  private

  def log_in_with(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
