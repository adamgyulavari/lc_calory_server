class Api::V1::ApiController < ApplicationController
  respond_to :json

  before_action :doorkeeper_authorize!
  before_action :authenticate_user!

  private

  def authenticate_user!
    if doorkeeper_token
      Thread.current[:current_user] = User.find(doorkeeper_token.resource_owner_id)
    end

    return if current_user

    render json: { errors: ['User is not authenticated!'] }, status: :unauthorized
  end

  def current_user
    Thread.current[:current_user]
  end
end
