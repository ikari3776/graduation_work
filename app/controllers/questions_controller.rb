class QuestionsController < ApplicationController
  require 'httparty'

  API_KEY = ENV['PIXABAY_API_KEY']

  def show
    @question = Question.find(params[:id])
  end

  def answer
    question = Question.find(params[:question_id])
    search_word = params[:search]
    image_id = question.image_id

    url = "https://pixabay.com/api/?key=#{API_KEY}&q=#{CGI.escape(search_word)}&image_type=photo&per_page=100"

    response = HTTParty.get(url)
    data = JSON.parse(response.body)

    top_images = data["hits"].first(10).map { |hit| hit["webformatURL"] }

    data["hits"].first(5).each_with_index do |hit, index|
      puts "#{index + 1}位: ID = #{hit['id']}, URL = #{hit['webformatURL']}"
    end

    rank = 100
    data["hits"].each_with_index do |hit, index|
      if hit["id"] == image_id
        rank = index + 1
        break
      end
    end

    points = if rank == 1
               200
             elsif rank <= 99
               100 - rank
             else
               0
             end
    question.update(search_word: search_word, rank: rank, score: points, search_results: top_images.to_json)

    redirect_to result_game_questions_path(game_id: question.game_id, question_id: question.id)
  end

  def result
    @game = Game.find(params[:game_id])
    @preview_question = Question.find(params[:question_id])
    @question = @game.questions.order(:id).find_by("rank IS NOT NULL")
    @next_question = @game.questions.where(rank: nil).first

    @top_images = JSON.parse(@preview_question.search_results || "[]")
  end
end
