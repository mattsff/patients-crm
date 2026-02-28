Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"

  resource :dashboard, only: :show, controller: "dashboard"

  resources :patients do
    resources :notes, only: [:create, :update, :destroy]
    resources :appointments, only: [:new, :create], controller: "patient_appointments"
  end

  resources :appointments do
    member do
      patch :complete
      patch :cancel
      patch :no_show
    end
  end

  resources :tags, only: [:index, :create, :update, :destroy]

  resource :clinic_settings, only: [:show, :update], controller: "clinic_settings"
  resources :staff, only: [:index, :new, :create, :destroy], controller: "staff"
end
