require 'swagger_helper'

RSpec.describe 'api/teams', type: :request do
  # Create a team
  path '/api/teams' do
    post('create team') do
      tags 'Teams'
      consumes 'application/json'
      security [BearerAuth: []] 

      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          team: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Team 1' },
              description: { type: :string, example: 'ROR team' }
            },
            required: ['name', 'description']
          }
        },
        required: ['team']
      }

      response(201, 'team created') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team) { { team: { name: 'Team 1', description: 'ROR team'} } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Team 1')
          expect(data['description']).to eq('ROR team')
          expect(data['owner_id']).to eq(1)
        end
      end

      response(422, 'unprocessable entity') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:team) { { team: { name: '', description: '' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to include("Name can't be blank", "Description can't be blank")
        end
      end
    end
  end

  # Index - Listing all teams
  path '/api/teams' do
    get('list teams') do
      tags 'Teams'
      security [BearerAuth: []]  

      response(200, 'list of teams') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)  # The response should be an array of teams
          expect(data.first).to include('id', 'name', 'description', 'owner_id')  
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }  # No authentication provided

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Unauthorized') 
        end
      end
    end
  end

  # Update a team
  path '/api/teams/{id}' do
    put('update team') do
      tags 'Teams'
      consumes 'application/json'
      security [BearerAuth: []] 

      parameter name: :id, in: :path, type: :integer, description: 'Team ID', example: 1
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          team: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Team 1' },
              description: { type: :string, example: 'ROR team' }
            },
            required: ['name', 'description']
          }
        },
        required: ['team']
      }

      response(200, 'team updated') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:id) { 1 }  # Use a valid team ID for testing
        let(:team) { { team: { name: 'team 266', description: 'ruby team' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('team 266')
          expect(data['description']).to eq('ruby team')
        end
      end

      response(422, 'unprocessable entity') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:id) { 1 }
        let(:team) { { team: { name: '', description: ''} } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to include("Name can't be blank", "Description can't be blank")
        end
      end

      response(404, 'team not found') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:id) { 999 }  # Use a non-existing team ID for testing

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Team not found') 
        end
      end
    end
  end

  # Delete a team
  path '/api/teams/{id}' do
    delete('delete team') do
      tags 'Teams'
      security [BearerAuth: []]  

      parameter name: :id, in: :path, type: :integer, description: 'Team ID', example: 1

      response(204, 'team deleted') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:id) { 1 }  # Use a valid team ID for testing

        run_test! do |response|
          expect(response.status).to eq(204)  
        end
      end

      response(404, 'team not found') do
        let(:Authorization) { "Bearer #{sign_in(user)}" }
        let(:id) { 999 }  # Use a non-existing team ID for testing

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Team not found')  
        end
      end
    end
  end
end
