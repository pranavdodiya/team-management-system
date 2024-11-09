class Api::TeamMembersController < ApplicationController
  before_action :set_team
  before_action :team_member_params, only: [:index]
  before_action :authorize_owner, only: [:create, :destroy]

  # POST /api/teams/:team_id/team_members
  def create
    user = User.find_by(id: params[:team_member][:user_id])

    if user.nil?
      return render json: { error: 'User not found' }, status: :not_found
    end

    team_member = @team.team_memberships.build(user: user)

    if team_member.save
      render json: team_member, status: :created
    else
      render json: team_member.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render_error("Failed to add team member: #{e.message}")
  end

  # DELETE /api/teams/:team_id/team_members/:id
  def destroy
    team_member = @team.team_memberships.find_by(id: params[:id])

    if team_member.nil?
      return render json: { error: 'Team member not found' }, status: :not_found
    end

    if team_member.destroy
      render json: { message: 'Team member removed successfully' }, status: :ok
    else
      render json: team_member.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render_error("Failed to remove team member: #{e.message}")
  end

  # GET /api/teams/:team_id/team_members
  def index

    # search by user name if query present  
    team_members = if params[:query]
      @team.members.where("users.name ILIKE :search", search: "%#{params[:query]}%")
    else
      @team.members
    end

    if team_members.empty?
      render json: { message: 'No team members found' }, status: :not_found
    else
      render json: team_members, status: :ok
    end
  rescue StandardError => e
    render_error("Failed to fetch team members: #{e.message}")
  end

  # GET /api/teams/:team_id/team_members/:id
  def show
    team_member = @team.team_memberships.find_by(id: params[:id])

    if team_member.nil?
      render json: { error: 'Team member not found' }, status: :not_found
    else
      user = team_member.user 
      render json: {
        team_member_id: team_member.id,
        user_id: user.id,
        email: user.email,
        name: user.name
      }, status: :ok
    end
  rescue StandardError => e
    render_error("Failed to fetch team member details: #{e.message}")
  end


  private

  # Sets the @team instance variable based on the team_id parameter.
  def set_team
    @team = Team.find_by(id: params[:team_id])
    render json: { error: 'Team not found' }, status: :not_found unless @team
  end

  # Permits the :query parameter for team member search functionality
  def team_member_params
    params.permit(:query)
  end

   # Authorizes the current API user as the owner of the team.
  def authorize_owner
    render json: { error: 'Unauthorized User' }, status: :unauthorized unless @team.owner == current_api_user
  end

  # used for handling exceptions and standardizing error responses - 500 status code
  def render_error(message)
    render json: { error: message }, status: :internal_server_error
  end
end
