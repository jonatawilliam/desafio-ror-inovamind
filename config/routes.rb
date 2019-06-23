Rails.application.routes.draw do
  get "/quotes/:search_tag", to: "quotes#search_tag"
end
