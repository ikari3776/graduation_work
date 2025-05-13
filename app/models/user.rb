class User < ApplicationRecord
  authenticates_with_sorcery!
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
  has_many :authentications, dependent: :destroy
  has_many :user_badges
  has_many :badges, through: :user_badges

  def badges_check
    score = Game.where(user_id: id).maximum(:total_score)
    game_count = Game.where(user_id: id).count

    self.badges = []

    self.badges << Badge.find_by(name: "初めてログインする")

    self.badges << Badge.find_by(name: "1000点以上獲得する") if score >= 1000
    self.badges << Badge.find_by(name: "1500点以上獲得する") if score >= 1500
    self.badges << Badge.find_by(name: "2000点以上獲得する") if score >= 2000
    self.badges << Badge.find_by(name: "2500点獲得する") if score >= 2500

    self.badges << Badge.find_by(name: "5回以上プレイする") if game_count >= 5
    self.badges << Badge.find_by(name: "10回以上プレイする") if game_count >= 10
    self.badges << Badge.find_by(name: "30回以上プレイする") if game_count >= 30
    self.badges << Badge.find_by(name: "50回以上プレイする") if game_count >= 50
    self.badges << Badge.find_by(name: "100回以上プレイする") if game_count >= 100
    self.badges << Badge.find_by(name: "500回以上プレイする") if game_count >= 500
    self.badges << Badge.find_by(name: "1000回以上プレイする") if game_count >= 1000

    self.badges
  end
end
