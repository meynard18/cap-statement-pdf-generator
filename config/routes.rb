Rails.application.routes.draw do
  get "pages/home"
  # get "capability_statements/new"
  # get "capability_statements/create"
  # get "capability_statements/show"

  resources :capability_statements, only: [ :new, :create, :show, :edit, :update] do
    member do
      get :download
      post :checkout, to: "checkouts#create"
    end
  end
  post "webhooks/stripe", to: "webhooks#stripe"
  root "pages#home"
end
