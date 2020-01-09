Rails.application.routes.draw do

  namespace :api, as: nil, defaults: { format: 'json' } do
    namespace :v1, as: nil do
      devise_for :users, defaults: { format: :json },
                 controllers: { sessions: 'api/v1/sessions',
                                registrations: 'api/v1/registrations'}
      resources :tweets, only: [:create] do
        get :feeds, on: :collection
        get :user_tweets, on: :collection
      end

      resources :follows, only: [] do
        put :follow, on: :collection
        put :unfollow, on: :collection
      end

      resources :users, only: [:show]
    end
  end
end
