# spec/requests/api/sessions_spec.rb
require 'swagger_helper'

RSpec.describe 'api/sessions', type: :request do
  path '/api/signup' do
    post('user signup') do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'abc123@gmail.com' },
              password: { type: :string, example: 'abc@123' },
              name: { type: :string, example: 'First User' }
            },
            required: ['email', 'password', 'name']
          }
        },
        required: ['user']
      }

      response(201, 'created') do
        let(:user) { { user: { email: 'abc123@gmail.com', password: 'abc@123', name: 'Admin User' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user']['email']).to eq('abc123@gmail.com')
          expect(data).not_to have_key('role') 
          expect(data).to have_key('token')
          expect(data['message']).to eq('Signup successful')
        end
      end

      response(422, 'unprocessable entity') do
        let(:user) { { user: { email: '', password: '', name: '' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to include("Email can't be blank", "Password can't be blank", "Name can't be blank")
        end
      end
    end
  end

  path '/api/signin' do
    post('user signin') do
      tags 'Authentication'
      consumes 'application/json'
      
      # Add security scheme here for Bearer token
      security [BearerAuth: []]  # This references the BearerAuth security definition

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'abc123@gmail.com' },
              password: { type: :string, example: 'abc@123' }
            },
            required: ['email', 'password']
          }
        }
      }

      response(200, 'successful') do
        let(:user) { User.create(email: 'abc123@gmail.com', password: 'abc@123') }
        let(:credentials) { { user: { email: user.email, password: 'abc@123' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user']['email']).to eq(user.email)
          expect(data).to have_key('token')
          expect(data['message']).to eq('Login successful')
        end
      end

      response(401, 'unauthorized') do
        let(:credentials) { { user: { email: 'abc123@gmail.com', password: 'wrongpassword' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Invalid email or password')
        end
      end
    end
  end
end
