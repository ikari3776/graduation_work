class GamesController < ApplicationController
  def new
    @game = Game.new(user: current_user, total_score: 0)

    if @game.save
      images = Image.order("RANDOM()").limit(5)

      images.each do |image|
        @game.questions.create(image_url: image.url, image_id: image.image_id, rank: nil, score: nil)
      end

      redirect_to game_question_path(@game, @game.questions.first)
    else
      puts "ゲームの保存に失敗: #{@game.errors.full_messages}"
      flash[:error] = "ゲームの作成に失敗しました: #{@game.errors.full_messages.join(', ')}"
      redirect_to root_path
    end
  end

  def result
    @game = Game.find(params[:game_id])
    @game.calculate_total_score
  end
end
