require 'rails_helper'

RSpec.describe "お問い合わせ", type: :system do
  describe "お問い合わせ画面" do
    it "お問い合わせ画面に遷移できる" do
      visit new_contact_path
      expect(page).to have_content("お問い合わせ")
    end
  end
end
