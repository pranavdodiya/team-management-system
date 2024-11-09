class User < ApplicationRecord

  # Associations
  # A user can own many teams, represented by the owned_teams association
  has_many :owned_teams, class_name: 'Team', foreign_key: :owner_id

  # A user can be a member of many teams through team memberships
  has_many :team_memberships, class_name: 'TeamMember'
  has_many :teams, through: :team_memberships

  # Devise modules for authentication
  # Database authentication, registration, password recovery, and rememberable session management
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # JWT authentication with revocation strategy using a denylist for token management
  devise :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Validations
  # Ensures that a user role is present and either "admin" or "member"
  validates :role, presence: true, inclusion: { in: %w[admin member] }

  # Callbacks
  # Sets the default role to "member" before validation on create if no role is specified
  before_validation :set_default_role, on: :create

  private

  # Method to set the default role to "member" if no role is provided
  def set_default_role
    self.role ||= 'member'
  end
end
