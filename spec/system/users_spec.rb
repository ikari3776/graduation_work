require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  describe "ユーザー登録画面" do
    before { visit new_user_path }

    it "有効な情報で登録できる" do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "ユーザー名", with: "firsthit"
      fill_in "パスワード", with: "password"
      fill_in "パスワード確認", with: "password"

      click_button "登録"

      expect(page).to have_content("ユーザー登録が完了しました")
      expect(page).to have_content("ログイン中: firsthit")
      expect(User.last.email).to eq "test@example.com"
      expect(current_path).to eq root_path
    end

    it "未入力だとエラーが表示される" do
      click_button "登録"

      expect(page).to have_content("メールアドレスを入力してください")
      expect(page).to have_content("ユーザー名は3文字以上で入力してください")
      expect(page).to have_content("パスワードは3文字以上で入力してください")
    end
  end

  describe "ログイン画面" do
    before { visit login_path }

    it "有効な情報でログインできる" do
      user = create(:user)
      fill_in "ユーザー名", with: user.name
      fill_in "パスワード", with: "password"

      click_button "ログイン"

      expect(page).to have_content("ログイン中: #{user.name}")
      expect(current_path).to eq root_path
    end

    it "未入力だとエラーが表示される" do
      click_button "ログイン"

      expect(page).to have_content("ユーザー名が存在しません")
    end
  end
end
