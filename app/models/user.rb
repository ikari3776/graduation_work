class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true,
                   uniqueness: true,
                   length: { in: 3..20 },
                   format: { with: /\A[a-zA-Z0-9]+\z/, message: "は半角英数字のみ使用できます" }
  validates :password, confirmation: true,
                       length: { minimum: 3 }
  validates :password_confirmation, length: { minimum: 3 }
end
