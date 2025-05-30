class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to root_path, success: "メールを送信しました。メールが届かない場合は、入力したメールアドレスが正しいかご確認ください。"
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      auto_login(@user)
      redirect_to root_path, success: "パスワードの変更が完了しました"
    else
      flash.now[:danger] = "パスワードを変更できませんでした"
      render :edit
    end
  end
end
