class Api::TeamsController < ApplicationController
  before_action :set_team, only: [:show, :update, :destroy]
  before_action :authorize_owner, only: [:update, :destroy]

  # GET /api/teams
  def index
    teams = Team.all
    render json: teams, status: :ok
  rescue StandardError => e
    render_error("Failed to fetch teams: #{e.message}")
  end

  # POST /api/teams
  def create
    team = Team.new(team_params)
    team.owner = current_api_user # Assign current user as the owner

    if team.save
      render json: team, status: :created
    else
      render json: team.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render_error("Failed to create team: #{e.message}")
  end

  # PATCH/PUT /api/teams/:id
  def update
    if @team.update(team_params)
      render json: @team, status: :ok
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render_error("Failed to update team: #{e.message}")
  end

  # DELETE /api/teams/:id
  def destroy
    if @team.destroy
      head :no_content
    else
      render_error("Failed to delete team")
    end
  rescue StandardError => e
    render_error("Failed to delete team: #{e.message}")
  end

  private

  # Sets the @team instance variable based on the id parameter from the request
  def set_team
    @team = Team.find_by(id: params[:id])
    render json: { error: 'Team not found' }, status: :not_found unless @team
  end

  # Strong parameters for team creation or update. Requires a team object and permits
  def team_params
    params.require(:team).permit(:name, :description, :owner_id)
  end

  # Checks if the current API user is the owner of the team.
  def authorize_owner
    return if @team.owner == current_api_user
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # Renders a standardized JSON error message and a 500 status code for any internal server errors.
  def render_error(message)
    render json: { error: message }, status: :internal_server_error
  end
end
