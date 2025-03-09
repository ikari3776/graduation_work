class GamesController < ApplicationController
  require "httparty"

  API_KEY = ENV["PIXABAY_API_KEY"]
  QUERY = [ "2024", "2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015" ]
  PER_PAGE = 200
  PAGE = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ].sample

  def new
    @game = Game.new(user: current_user, total_score: 0)

    if @game.save
      url = "https://pixabay.com/api/?key=#{API_KEY}&q=#{QUERY}&image_type=photo&per_page=#{PER_PAGE}&page=#{PAGE}}"

      response = HTTParty.get(url)
      data = JSON.parse(response.body)

      if data["hits"].any?
        images = data["hits"].sample(5).map do |hit|
          {
            image_id: hit["id"],
            url: hit["webformatURL"]
          }
        end
      end

      images.each_with_index do |image, index|
        @game.questions.create(
          image_url: image[:url],
          image_id: image[:image_id],
          rank: nil,
          score: nil,
          number: index + 1
        )
      end

      redirect_to game_question_path(@game, 1)
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
