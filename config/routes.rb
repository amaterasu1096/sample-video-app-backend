Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      post 'share_video', to: 'videos#share'
      get 'videos', to: 'videos#index'
      post 'videos/:video_id/vote', to: 'votes#create'
    end
  end
end
