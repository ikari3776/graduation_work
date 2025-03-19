class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー登録が完了しました"
      redirect_to login_path
    else
      flash.now[:danger] = "ユーザー登録に失敗しました"
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "ユーザー編集が完了しました"
      redirect_to root_path
    else
      flash.now[:danger] = "ユーザー編集に失敗しました"
      render :edit
    end
  end

  def new_name
    @user = User.find(session[:user_id])
  end

  def create_name
    @user = User.find(session[:user_id])
    
    if @user.update(name_params)
      reset_session
      auto_login(@user)
      flash[:success] = "ユーザー名を設定しました"
      redirect_to root_path
    else
      flash[:danger] = "ユーザー名の設定に失敗しました"
      render :new_name
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :email)
  end

  def name_params
    params.require(:user).permit(:name)
  end
end
