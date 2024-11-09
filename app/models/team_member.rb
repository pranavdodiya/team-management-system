class TeamMember < ApplicationRecord
  # Associations
  # Each team member record links a specific user to a specific team
  belongs_to :team
  
  # Each team member belongs to a user, establishing a many-to-many relationship 
  # between teams and users through this model
  belongs_to :user
end
