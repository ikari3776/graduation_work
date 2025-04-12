class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    user_hash = sorcery_fetch_user_hash(provider)

    if user_hash.nil?
      access_token = @access_token.token rescue nil
      user_info = fetch_google_user_info(access_token)

      if user_info.present?
        Rails.logger.info "user_info: #{user_info.inspect}"
        uid = user_info["sub"]
        email = user_info["email"]
      else
        raise "Failed to fetch user info manually!"
      end
    else
      user_info = user_hash[:user_info]
      uid = user_hash[:uid] || user_info["sub"]
    end

    if (@auth = Authentication.find_by(provider: provider, uid: uid))
      @user = @auth.user
      auto_login(@user)
      flash[:success] = "#{provider.titleize} アカウントでログインしました"
      redirect_to root_path
    else
      begin
        signup_and_login(provider, user_info)
        if @user.name.start_with?("firsthit")
          session[:user_id] = @user.id
          redirect_to new_name_path
        else
          flash[:success] = "#{provider.titleize} アカウントでログインしました"
          redirect_to root_path
        end
      rescue StandardError => e
        flash[:danger] = "#{provider.titleize} アカウントでのログインに失敗しました"
        redirect_to root_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :scope, :authuser, :prompt)
  end

  def signup_and_login(provider, user_info)
    random_password = SecureRandom.hex(10)
    temp_name = "firsthit#{SecureRandom.hex(3)}"

    @user = User.create!(
      email: user_info["email"],
      password: random_password,
      password_confirmation: random_password,
      name: temp_name
    )

    @user.authentications.create!(
      provider: provider,
      uid: user_info["sub"]
    )

    reset_session
    auto_login(@user)
  end

  def fetch_google_user_info(access_token)
    response = HTTParty.get("https://www.googleapis.com/oauth2/v3/userinfo", {
      headers: {
        "Authorization" => "Bearer #{access_token}"
      }
    })

    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end
end
