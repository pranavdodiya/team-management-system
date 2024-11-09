class Api::SessionsController < ApplicationController
  # POST /api/signup
  def signup
    user = User.new(signup_params)
    user.role = 'member'  # Assign 'member' role by default

    if user.save
      token = generate_jwt_token(user)
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/signin
  def signin
    user = User.find_by(email: signin_params[:email])

    if user&.valid_password?(signin_params[:password])
      token = generate_jwt_token(user)
      render json: { user: user, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  # Strong parameters for signup action
  def signup_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  # Strong parameters for signin action
  def signin_params
    params.require(:user).permit(:email, :password)
  end

  # Securely generate JWT token
  def generate_jwt_token(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.credentials[:jwt_secret_key])
  end
end
