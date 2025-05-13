class RanksController < ApplicationController
  def index
    @ranks = User
              .joins(:games)
              .select(
                "users.*",
                "MAX(games.total_score) AS max_total_score",
                "MAX(games.finished_at) AS latest_finished_at"
              )
              .group("users.id")
              .order("max_total_score DESC")
              .limit(10)
              .includes(:badges)

    if logged_in?
      @user_score = Game.where(user_id: current_user.id).maximum(:total_score)

      all_ranks = User
                    .joins(:games)
                    .select("users.id, MAX(games.total_score) AS max_total_score")
                    .group("users.id")
                    .order("max_total_score DESC")

      @user_rank = all_ranks.index { |rank| rank.id == current_user.id } rescue nil
    end
  end
end
