# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # def create
  #   user = User.find_by(email: params[:session][:email])
  #   if user && user.authenticate(params[:session][:password])
  #     log_in(user)
  #     flash[:success] = "Successfully logged in"
  #     redirect_to root_url
  #   else
  #     flash[:danger] = "Invaild Credentials"
  #     redirect_to new_user_session_path
  #   end 
  # end
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

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
