class QuestionsController < ApplicationController
  require "httparty"

  API_KEY = ENV["PIXABAY_API_KEY"]

  def show
    @game = Game.find(params[:game_id])
    @question = @game.questions.find_by(number: params[:number])
  end

  def answer
    question = Question.find(params[:question_id])
    search_word = params[:search]
    image_id = question.image_id

    url = "https://pixabay.com/api/?key=#{API_KEY}&q=#{CGI.escape(search_word)}&image_type=photo&per_page=200"

    response = HTTParty.get(url)
    data = JSON.parse(response.body)

    top_images = data["hits"].first(10).map { |hit| hit["webformatURL"] }

    rank = 200
    data["hits"].each_with_index do |hit, index|
      if hit["id"] == image_id
        rank = index + 1
        break
      end
    end

    points = if rank == 1
               500
    elsif rank <= 199
               200 - rank
    else
               0
    end
    question.update(search_word: search_word, rank: rank, score: points, search_results: top_images.to_json)

    redirect_to result_game_questions_path(game_id: question.game_id, number: question.number)
  end

  def result
    @game = Game.find(params[:game_id])
    @preview_question = @game.questions.find_by(number: params[:number])
    @next_question = @game.questions.find_by(number: @preview_question.number + 1)

    @top_images = JSON.parse(@preview_question.search_results || "[]")
  end
end
