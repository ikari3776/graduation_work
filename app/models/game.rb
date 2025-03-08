class Game < ApplicationRecord
  belongs_to :user, optional: true
  has_many :questions, dependent: :destroy
  enum status: { not_start: 0, playing: 1, finished: 2 }

  def calculate_total_score
    self.update(total_score: questions.sum(:score), finished_at: Time.current)
  end

  def playing?
    status == "playing"
  end
end
