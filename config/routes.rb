Rails.application.routes.draw do
  get 'bloggy/home'
  get '/pages', to: 'pages#index', as: 'all_pages'
  devise_for :users, controllers: { sessions: 'users/sessions' }
  get '/pages/new', to: 'pages#new', as: 'new_page'
  get '/pages/:id', to:'pages#show', as: 'page'
  post '/pages', to: 'pages#create'
  get '/create', to: 'pages#create'
  get 'create_user', to: 'pages#new'
  get '/practice', to: 'pages#new'
  post '/practice', to: 'pages#new'
  post '/email', to: 'pages#email'
  post '/article', to: 'pages#article'
  post '/attribute', to: 'pages#attribute'
  delete '/delete/:id', to:'pages#delete'
  delete '/deleteArticle/:id', to:'pages#deleteArticle'
  get '/updatec/:id', to:'pages#updatec'
  post '/updatecontact/:id', to:'pages#updateuser'
  get '/updateArticle/:id', to:'pages#update'
  post '/updatearticle1/:id', to:'pages#updatearticle1'
  get '/reports', to: 'pages#reports', as: 'reports'
end


