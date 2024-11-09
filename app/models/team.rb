class Team < ApplicationRecord
  # Associations
  # A team is owned by a user, specified as 'owner' with a foreign key relationship
  belongs_to :owner, class_name: 'User'

  # A team can have many team memberships that link users to the team
  has_many :team_memberships, class_name: 'TeamMember'

  # A team has many members (users) through team memberships
  has_many :members, through: :team_memberships, source: :user
end
