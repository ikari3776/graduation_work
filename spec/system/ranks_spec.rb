require 'rails_helper'

RSpec.describe "ランキング画面", type: :system do
  describe "ログイン前" do
    it "ランキング画面に遷移できる" do
      visit ranks_path
      expect(current_path).to eq ranks_path
      expect(page).to have_content("ランキング")
      expect(page).to have_content("ログインするとランキングに参加できます")
    end
  end

  describe "ログイン後" do
    it "ランキング画面に遷移できる" do
      user = create(:user)
      visit login_path
      fill_in "ユーザー名", with: user.name
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      expect(page).to have_content("ログイン中: #{user.name}")
      visit ranks_path
      expect(current_path).to eq ranks_path
      expect(page).to have_content("ランキング")
      expect(page).to have_content("まだゲームをプレイしていません")
    end
  end
end
