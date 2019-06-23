Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  get "/quotes/:search_tag", to: "quotes#search_tag"
end
