require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    subject { build(:user) }

    it "設定したすべてのバリデーションが機能しているか" do
      expect(subject).to be_valid
    end

    context "nameのバリデーション" do
      it "nameがないと無効" do
        subject.name = nil
        expect(subject).to_not be_valid
        expect(subject.errors[:name]).to include("を入力してください")
      end

      it "nameが3文字未満だと無効" do
        subject.name = "aa"
        expect(subject).to_not be_valid
      end

      it "nameが20文字を超えると無効" do
        subject.name = "a" * 21
        expect(subject).to_not be_valid
      end

      it "nameが重複すると無効" do
        create(:user, name: subject.name)
        expect(subject).to_not be_valid
      end

      it "nameに全角文字が含まれると無効" do
        subject.name = "ユーザー"
        expect(subject).to_not be_valid
      end
    end

    context "emailのバリデーション" do
      it "emailがないと無効" do
        subject.email = nil
        expect(subject).to_not be_valid
      end

      it "emailの形式が正しくないと無効" do
        subject.email = "invalid_email"
        expect(subject).to_not be_valid
      end

      it "emailが重複すると無効" do
        create(:user, email: subject.email)
        expect(subject).to_not be_valid
      end
    end

    context "passwordのバリデーション" do
      it "passwordがないと無効" do
        subject.password = nil
        subject.password_confirmation = nil
        expect(subject).to_not be_valid
      end

      it "password_confirmationが一致しないと無効" do
        subject.password_confirmation = "wrongpassword"
        expect(subject).to_not be_valid
      end

      it "passwordが3文字未満だと無効" do
        subject.password = subject.password_confirmation = "aa"
        expect(subject).to_not be_valid
      end
    end

    context "reset_password_tokenのバリデーション" do
      it "重複したreset_password_tokenは無効" do
        create(:user, reset_password_token: "token123")
        user2 = build(:user, reset_password_token: "token123")
        expect(user2).to_not be_valid
      end
    end
  end
end
