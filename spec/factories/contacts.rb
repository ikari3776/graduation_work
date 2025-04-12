FactoryBot.define do
    factory :contact do
      name { "問い合わせ太郎" }
      email { "contact@example.com" }
      subject { "お問い合わせについて" }
      message { "メッセージ本文です" }
    end
  end
