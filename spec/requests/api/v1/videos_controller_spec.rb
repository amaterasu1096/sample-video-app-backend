require 'rails_helper'

RSpec.describe Api::V1::VideosController, type: :request do
  let(:user) { create(:user) }
  let(:headers) do
    token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
    { "Authorization" => "Bearer #{token}" }
  end

  describe "POST /api/v1/share_video" do
    context "when the request is valid" do
      let(:valid_attributes) { { video_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" } }

      it "shares the video" do
        post "/api/v1/share_video", params: valid_attributes, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("message" => "Video shared successfully")
      end
    end

    context "when the request is empty params" do
      it "returns a validation failure message" do
        post "/api/v1/share_video", headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error")
      end
    end

    context "when the request is invalid" do
      let(:invalid_attributes) { { video_url: "" } }

      it "returns a validation failure message" do
        post "/api/v1/share_video", params: invalid_attributes, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error")
      end
    end

    context "when the user is not authenticated" do
      let(:valid_attributes) { { video_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" } }

      it "returns an unauthorized message" do
        post "/api/v1/share_video", params: valid_attributes

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("error" => "Not Authorized")
      end
    end
  end
end
