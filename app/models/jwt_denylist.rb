class JwtDenylist < ApplicationRecord
  validates :jti, presence: true, uniqueness: true
end
  