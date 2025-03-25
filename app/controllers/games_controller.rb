class GamesController < ApplicationController
  def index
    session[:game_round] ||= 1
    session[:total_score] ||= 0

    session[:game_images] ||= Image.where.not(embedding: nil).order("RANDOM()").limit(5).pluck(:id)

    @random_image = Image.find_by(id: session[:game_images][session[:game_round] - 1])

    if @random_image.nil?
      flash[:alert] = "画像が見つかりませんでした"
      redirect_to root_path and return
    end
  end

  def search
    @random_image = Image.find_by(id: params[:image_id]) # フォームから送られてきた画像IDを取得

    if @random_image.nil?
      flash[:alert] = "画像が見つかりませんでした"
      redirect_to root_path and return
    end

    if params[:query].present?
      @query_text = params[:query]
      @query_embedding = EmbeddingGenerator.generate_embedding(@query_text) # 検索ワードの埋め込みを生成
      @similar_images = Image.find_similar_images(@query_embedding, limit: 10)

      @position = @similar_images.index { |h| h[:image].id == @random_image.id }&.+(1)
      @score = calculate_score(@position)

      session[:total_score] += @score
      @current_round = session[:game_round]

      session[:game_round] += 1 if session[:game_round] <= 5

      render :search
    else
      flash[:alert] = "検索ワードを入力してください"
      redirect_to games_path
    end
  end

  def result
    @total_score = session[:total_score]

    session.delete(:game_round)
    session.delete(:total_score)
    session.delete(:game_images)
  end

  def reset_game_session
    reset_session
    head :ok
  end

  private

  def calculate_score(position)
    return 500 if position == 1
    return (100 - position) if position && position <= 100
    return 0
  end
end
