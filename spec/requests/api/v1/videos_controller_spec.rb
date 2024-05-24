require 'rails_helper'

RSpec.describe Api::V1::VideosController, type: :request do
  let(:user) { create(:user) }
  let(:headers) do
    token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
    { "Authorization" => "Bearer #{token}" }
  end
  let(:videos) { create_list(:video, 20, user: user) }

  describe "GET /api/v1/videos" do
    before { videos }

    context "when the user is not authenticated" do
      it "returns the list of videos without votes" do
        get "/api/v1/videos", params: { page: 1 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["videos"].size).to eq(5)
        expect(json_response["videos"].first).to include("id" => videos.last.id, "title" => videos.last.title, "description" => videos.last.description, "url" => videos.last.url, "email" => user.email, "vote" => nil)
        expect(json_response["meta"]["current_page"]).to eq(1)
        expect(json_response["meta"]["total_pages"]).to eq(4)
        expect(json_response["meta"]["total_count"]).to eq(20)
      end
    end

    context "when the user is authenticated" do
      before { create(:vote, :upvote, user: user, video: videos.last) }

      it "returns the list of videos with votes" do
        get "/api/v1/videos", params: { page: 1 }, headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["videos"].size).to eq(5)
        expect(json_response["videos"].first).to include("id" => videos.last.id, "title" => videos.last.title, "description" => videos.last.description, "url" => videos.last.url, "email" => user.email, "vote" => "upvote")
        expect(json_response["meta"]["current_page"]).to eq(1)
        expect(json_response["meta"]["total_pages"]).to eq(4)
        expect(json_response["meta"]["total_count"]).to eq(20)
      end
    end
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
