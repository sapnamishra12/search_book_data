class ApplicationController < ActionController::API

	include JwtToken

  attr_reader :current_user

  def render_error message
    render :json =>{
      code: 400,
      message: message
    }
  end

  def render_success message,data
    render :json => {
      code: 200,
      message: message,
      data: data
    }
  end

  def render_unauthorized message
    render :json => {
      code: 401,
      error: message
    }, status: :unauthorized
  end

  protected

    def authenticate_request!
      unless user_id_in_token?
        render_unauthorized('Not Authenticated')
        return
      end
      @current_user = User.find(BSON::ObjectId.from_string(auth_token[:user_id]))
    rescue JWT::VerificationError, JWT::DecodeError
      render_unauthorized('Not Authenticated')
    rescue Exception
      render_unauthorized('Not Authorized')
    end

  private

    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    def auth_token
      @auth_token ||= decode(http_token)
    end

    def user_id_in_token?
      http_token && auth_token && auth_token[:user_id].to_s
    end
end