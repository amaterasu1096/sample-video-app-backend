require 'rails_helper'

RSpec.describe Api::V1::VotesController, type: :request do
  let(:user) { create(:user) }
  let(:video) { create(:video) }
  let(:headers) do
    token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
    { "Authorization" => "Bearer #{token}" }
  end

  describe "POST /api/v1/videos/:video_id/vote" do
    context "when the user is not authenticated" do
      it "returns unauthorized error" do
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'upvote' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when the user is authenticated" do
      it "creates an upvote if not voted before" do
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'upvote' }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Vote created successfully')
        expect(JSON.parse(response.body)['vote_type']).to eq('upvote')
      end

      it "removes the upvote if already upvoted" do
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'upvote' }, headers: headers
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'upvote' }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Upvote removed successfully')
        expect(JSON.parse(response.body)['vote_type']).to be_nil
      end

      it "updates the upvote to downvote" do
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'upvote' }, headers: headers
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'downvote' }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Vote updated successfully')
        expect(JSON.parse(response.body)['vote_type']).to eq('downvote')
      end

      it "removes the downvote if already downvoted" do
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'downvote' }, headers: headers
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'downvote' }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Downvote removed successfully')
        expect(JSON.parse(response.body)['vote_type']).to be_nil
      end
    end

    context "when the vote_type is invalid" do
      it "returns an error" do
        post "/api/v1/videos/#{video.id}/vote", params: { vote_type: 'invalid_vote' }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid vote type')
      end
    end
  end
end
