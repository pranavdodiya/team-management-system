class CreateTeamMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :team_members do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
