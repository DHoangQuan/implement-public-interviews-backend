# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :accounts, only: %i[create index] do
        collection do
          put :verified
          put :unverified

          post ':sender_id/transfer', to: 'histories#transfer_balance'
        end

        put '/withdraw', to: 'wallets#withdraw'
        put '/deposit', to: 'wallets#deposit'
        get '/history', to: 'histories#index'
      end
    end
  end
end
