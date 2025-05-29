# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :hide_header, only: [ :new, :create ]
  # prepend_before_action :verify_recaptcha, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  # def verify_recaptcha
  #   token = params["recaptcha_token"]
  #   unless Recaptcha.verify_v3(response: token, action: "login", minimum_score: 0.5, )
  #     self.resource = resource_class.new sign_in_params
  #     flash[:alert] = "reCAPTCHAによる認証に失敗しました。もう一度お試しください。"
  #     response_with_navigational(resource) { render :new }
  #   end
  # end

  def hide_header
    @show_header = false
  end
end
