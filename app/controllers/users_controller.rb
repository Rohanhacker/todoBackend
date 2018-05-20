# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[show update destroy]
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { id: @user.id, email: @user.email, name: @user.name },
             status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: { id: @user.id, email: @user.email, name: @user.name }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
    if @user.id != current_user.id
      render json: { error: 'unauthorized' }, status: :not_found
    end
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.fetch(:user, {})
    params.permit(:name, :email, :password)
  end
end
