Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      post 'share_video', to: 'videos#share'
      get 'videos', to: 'videos#index'
    end
  end
end
