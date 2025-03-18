class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.reset_password_mailer = UserMailer
  end

  validates :name, presence: true,
                   uniqueness: true,
                   length: { in: 3..20 },
                   format: { with: /\A[a-zA-Z0-9]+\z/, message: "は半角英数字のみ使用できます" }
  validates :password, confirmation: true,
                       length: { minimum: 3 }, on: :create
  validates :password_confirmation, length: { minimum: 3 }, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_many :games, dependent: :destroy
end
