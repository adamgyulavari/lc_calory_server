class Api::V1::UsersController < Api::V1::ApiController
  skip_before_action :doorkeeper_authorize!, only: :create
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token, only: :create

  def index
    render json: current_user.to_json
  end

  def create
    user = User.new(signup_params)
    if user.save
      render json: user.to_json, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes update_params
      render json: user.to_json, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def signup_params
    params.permit(:email, :password)
  end

  def update_params
    params.permit(:goal)
  end
end
