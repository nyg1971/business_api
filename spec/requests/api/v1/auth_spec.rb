# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auths', type: :request do
  describe 'POST /api/v1/auth/signup' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end
    it 'creates a new user and returns JWT token' do
      post '/api/v1/auth/signup', params: valid_params, as: :as_json

      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to have_key('token')
    end
  end
  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }
    it 'returns JWT token for valid credentials' do
      post '/api/v1/auth/login', params:
        {
          email: 'test@example.com',
          password: 'password123'
        }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to have_key('token')
    end
  end
end
