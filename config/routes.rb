Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root "meetings#index"

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users
    
    resources :meetings, only: [] do
      member do
        get :assign_speakers
        post :bulk_assign
      end
      collection do
        get :import_from_text
        post :process_import
      end
    end
  end

  resources :meetings do
    member do
      get :pdf
    end
    
    resources :schedule_items, only: [:create, :update, :destroy] do
      collection do
        post :reorder
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
