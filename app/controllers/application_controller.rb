class ApplicationController < ActionController::API
  before_action :authenticate_user!, except: [:signup, :signin]

  private

  def authenticate_user!
    token = extract_token_from_header

    unless token
      render json: { error: 'Unauthorized, no token provided' }, status: :unauthorized
      return
    end

    decoded_token = decode_jwt_token(token)
    
    if decoded_token.nil? || !decoded_token[:user_id]
      render json: { error: 'Unauthorized, invalid token' }, status: :unauthorized
      return
    end

    @current_api_user = User.find_by(id: decoded_token[:user_id])
    
    unless @current_api_user
      render json: { error: 'Unauthorized, user not found' }, status: :unauthorized
    end
  end

  def current_api_user
    @current_api_user
  end

  def extract_token_from_header
    # Extracts the token from the Authorization header
    request.headers['Authorization']&.split(' ')&.last
  end

  def decode_jwt_token(token)
    # Decodes the JWT token and returns the payload
    begin
      JWT.decode(token, secret_key, true, algorithm: 'HS256').first.symbolize_keys
    rescue JWT::DecodeError
      nil
    end
  end

  def secret_key
    # Retrieves the secret key from environment variables
    ENV['JWT_SECRET_KEY'] || 'fallback_secret_key'
  end
end
