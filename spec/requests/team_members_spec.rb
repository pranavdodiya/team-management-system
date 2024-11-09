require 'swagger_helper'

RSpec.describe 'api/team_members', type: :request do
  # Add team member to a specific team
  path '/api/teams/{team_id}/team_members' do
    post('add team member') do
      tags 'Team Members'
      consumes 'application/json'
      security [BearerAuth: []] 

      parameter name: :team_id, in: :path, type: :integer, description: 'Team ID', example: 1
      parameter name: :team_member, in: :body, schema: {
        type: :object,
        properties: {
          team_member: {
            type: :object,
            properties: {
              user_id: { type: :integer, example: 1 }
            },
            required: ['user_id']
          }
        },
        required: ['team_member']
      }

      response(201, 'team member added') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:team_member) { { team_member: { user_id: 1 } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['team_id']).to eq(1)
          expect(data['user_id']).to eq(1)
        end
      end

      response(404, 'user not found') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:team_member) { { team_member: { user_id: 999 } } }  # Non-existing user ID

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('User not found')
        end
      end

      response(422, 'unprocessable entity') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:team_member) { { team_member: { user_id: nil } } }  # Missing user ID

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to include("User can't be blank")
        end
      end
    end
  end

  # Show a specific team member
  path '/api/teams/{team_id}/team_members/{id}' do
    get('show team member') do
      tags 'Team Members'
      security [BearerAuth: []]  

      parameter name: :team_id, in: :path, type: :integer, description: 'Team ID', example: 1
      parameter name: :id, in: :path, type: :integer, description: 'Team Member ID', example: 1

      response(200, 'team member details') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:id) { 1 }  # Valid team member ID (ID of team_memberships table)

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(1)  # Assuming user ID 1
          expect(data['email']).to eq('praaasdsdodiya72@gmail.com')
          expect(data['name']).to eq('nameeee')
          expect(data['role']).to eq('member')
        end
      end

      response(404, 'team member not found') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:id) { 999 }  # Non-existing team member ID

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Team member not found')
        end
      end
    end
  end

  # List all team members of a specific team with optional search functionality
  path '/api/teams/{team_id}/team_members' do
    get('list team members') do
      tags 'Team Members'
      security [BearerAuth: []]  
  
      parameter name: :team_id, in: :path, type: :integer, description: 'Team ID', example: 1
      parameter name: :query, in: :query, type: :string, description: 'Search query for team member name (optional)', required: false
  
      response(200, 'list of team members') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
  
        context 'when query parameter is present' do
          let(:query) { 'search_term' }
  
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to be_an(Array)  # The response should be an array of team members
            expect(data).not_to be_empty  # Ensures that we receive results if there are matches
            expect(data.first).to include('id', 'email', 'name', 'role')  # Check for expected fields
          end
        end
  
        context 'when query parameter is not present' do
          let(:query) { nil }
  
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to be_an(Array)  # The response should be an array of team members
            expect(data.first).to include('id', 'email', 'name', 'role')  
          end
        end
      end
  
      response(404, 'no team members found') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:query) { 'non_matching_term' }
  
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('No team members found')
        end
      end
    end
  end

  # Remove a team member from a team
  path '/api/teams/{team_id}/team_members/{id}' do
    delete('remove team member') do
      tags 'Team Members'
      security [BearerAuth: []]  # Ensure this matches your API security scheme

      parameter name: :team_id, in: :path, type: :integer, description: 'Team ID', example: 1
      parameter name: :id, in: :path, type: :integer, description: 'Team Member ID', example: 1

      response(200, 'team member removed') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:id) { 1 }  # Valid team member ID (ID of team_memberships table)

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Team member removed successfully')
        end
      end

      response(404, 'team member not found') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team_id) { 1 }
        let(:id) { 999 }  # Non-existing team member ID

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Team member not found')
        end
      end
    end
  end
end
