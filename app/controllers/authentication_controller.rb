class AuthenticationController < ApplicationController
  #module included for  
  include JwtToken

  def user_authentication
    user = User.find_for_database_authentication(email: params[:email])
    if user && user.valid_password?(params[:password])
      render json: payload(user)
    else
      render_unauthorized('Invalid Username/Password')
    end
  end

  private

    def payload(user)
      return nil unless user and user.id
      {
        auth_token: encode({user_id: user.id.to_s}),
        user: {id: user.id.to_s, email: user.email}
      }
    end
end