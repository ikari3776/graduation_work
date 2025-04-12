require 'rails_helper'

RSpec.describe "遊び方説明画面", type: :system do
  describe "遊び方説明画面" do
    it "遊び方説明画面に遷移できる" do
      visit rules_path
      expect(current_path).to eq rules_path
      expect(page).to have_content("遊び方")
    end
  end
end
