class UsersController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate, only: [:create, :update, :destroy]
  before_action :set_user, only: [:show, :create, :update, :destroy]

  #GET /users/{user_id}
  def show
    if user.present?
      if user.nickname.nil?
        user.nickname = user.user_id
      end
      render status: 200, json: {
        message: 'User details by user_id',
        data: user
      }
    end
  end

  #POST /signup
  def create
    if user.save
      render status: 200, json: {
        message: 'Account successfully created',
        data: user
      }
    else
      render status: 400, json: {
        message: 'Account creation failed',
        data: user.errors
      }
    end
  end

  #PATCH /users/{user_id}
  def update
    if params[:nickname].nil? && params[:comment].nil?
      render status: 400, json: {
        message: "User updation failed",
        cause: "required nickname or comment"
      }
      return
    elsif user.user_id != params[:user_id] || user.password != params[:password]
      render status: 400, json: {
        message: "User updation failed",
        cause: "not updatable user_id and password"
      }
      return
    end
    if user.update(user_params)
      render status: 200, json: {
        message: 'User successfully updated',
        data: user
      }
    else
      render status: 400, json: {
        message: 'Authentication Failed',
        data: user
      }
    end
  end

  #Post /close
  def destroy
    if user.destroy
      render status: 200, json: {
        message: 'Account and user successfully removed',
        data: user
      }
    else
      render status: 401, json: {
        message: 'Authentication Failed',
        data: user
      }
    end
  end

  private

  def set_user
    user = User.find_by(user_id: params[:user_id])
    if user.nil?
      render status: 404, json: {
        message: "No User found"
      } unless user.present? and return
    end
  end

  def user_params
    params.require(:user).permit(:user_id, :password, :nickname, :comment)
  end

  def check_user_id
    user = User.find_by(user_id: params[:user_id])
    if user.present?
      render status: 400, json: {
        message: "Account creation failed",
        cause: "already same user_id is used"
      } and return
    end
  end

  # Basic <base64エンコードされた {user_id} + ':' + {password}>
  def authenticate
    authenticate_with_http_token do |token|
      user_id = Base64.decode64(token).gsub(/:\w*/, '')
      password = Base64.decode64(token).gsub(/\w*:/, '')
      auth_user = User.find_by(user_id: user_id, password: password)
      auth_user = auth_user.present? ? true : false
    end
    if auth_user == false
      render status: 401, json: {
        message: "Authentication Faild"
      } and return
    end
  end
end
