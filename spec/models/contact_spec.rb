require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "バリデーション" do
    subject { build(:contact) }

    it "有効なファクトリを持つこと" do
      expect(subject).to be_valid
    end

    context "nameのバリデーション" do
      it "nameがなければ無効" do
        subject.name = nil
        expect(subject).to_not be_valid
        expect(subject.errors[:name]).to include("を入力してください")
      end
    end

    context "emailのバリデーション" do
      it "emailが空なら有効" do
        subject.email = ""
        expect(subject).to be_valid
      end

      it "emailの形式が不正なら無効" do
        subject.email = "invalid_email"
        expect(subject).to_not be_valid
        expect(subject.errors[:email]).to include("は不正な値です")
      end
    end

    context "subjectのバリデーション" do
      it "subjectがなければ無効" do
        subject.subject = nil
        expect(subject).to_not be_valid
        expect(subject.errors[:subject]).to include("を入力してください")
      end
    end

    context "messageのバリデーション" do
      it "messageがなければ無効" do
        subject.message = nil
        expect(subject).to_not be_valid
        expect(subject.errors[:message]).to include("を入力してください")
      end
    end
  end
end
