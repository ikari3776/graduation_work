class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:name], params[:password])
    user = User.find_by(name: params[:name])

    if user.nil?
      flash.now[:danger] = "ユーザー名が存在しません"
      render :new, status: :unprocessable_entity
    elsif login(params[:name], params[:password])
      flash[:success] = "ログインしました"
      redirect_to root_path
      nil
    else
      flash.now[:danger] = "パスワードが間違っています"
      render :new
    end
  end

  def destroy
    logout
    flash[:success] = "ログアウトしました"
    redirect_to root_path, status: :see_other
  end
end
