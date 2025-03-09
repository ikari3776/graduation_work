class RateLimitInfo < ApplicationRecord
  validates :limit, presence: true
  validates :remaining, presence: true
end
