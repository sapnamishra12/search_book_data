Rails.application.routes.draw do
  #authenticate user
  post 'user_authentication' => 'authentication#user_authentication'
  #search data
  get "/search", :to => "search#search_data"
end
