class GamesController < ApplicationController
  def index
    @image_url = Image.order("RANDOM()").first.url
  end
end
