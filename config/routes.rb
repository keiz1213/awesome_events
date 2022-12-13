Rails.application.routes.draw do
  root 'welcom#index'
  get '/auth/:provider/callback' => 'sessions#create'
end
