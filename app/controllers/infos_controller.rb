class InfosController < ApplicationController
  def index
    @rate_limits = RateLimitInfo.order(created_at: :desc).limit(10)
  end
end
