class RanksController < ApplicationController
  def index
    @ranks = Game.joins(:user)
                 .where.not(user_id: nil)
                 .group("users.id, users.name")
                 .select("users.name, MAX(games.total_score) AS max_total_score, MAX(games.finished_at) AS latest_finished_at")
                 .order("max_total_score DESC")
                 .limit(10)

    if logged_in?
    @user_score = Game.where(user_id: current_user.id).maximum(:total_score)

    all_ranks = Game.joins(:user)
                    .where.not(user_id: nil)
                    .group("users.id")
                    .select("users.id, MAX(games.total_score) AS max_total_score")
                    .order("max_total_score DESC")

    @user_rank = all_ranks.index { |rank| rank.id == current_user.id } rescue nil
    end
  end
end
