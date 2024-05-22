require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :request do
  describe 'POST /api/v1/authenticate' do
    let(:valid_attributes) { { email: 'user@example.com', password: 'password' } }
    let(:invalid_password_attributes) { { email: 'user@example.com', password: 'wrong_password' } }
    let(:non_existing_user_attributes) { { email: 'newuser@example.com', password: 'password' } }
    let(:user) { create(:user, email: 'user@example.com', password: 'password') }

    context 'when the user exists and password is correct' do
      before { user }

      it 'returns a valid token' do
        post '/api/v1/authenticate', params: valid_attributes
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['email']).to eq(user.email)
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end
    end

    context 'when the user exists but password is incorrect' do
      before { user }

      it 'returns an unauthorized status' do
        post '/api/v1/authenticate', params: invalid_password_attributes
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid password')
      end
    end

    context 'when the user does not exist' do
      it 'creates a new user and returns a token' do
        post '/api/v1/authenticate', params: non_existing_user_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['email']).to eq(non_existing_user_attributes[:email])
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end

      it 'returns an unprocessable entity status if user creation fails' do
        invalid_attributes = { email: 'newuser@example.com', password: '' }
        post '/api/v1/authenticate', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include("Password can't be blank")
      end
    end
  end
end
