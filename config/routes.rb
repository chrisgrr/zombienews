Rails.application.routes.draw do
  root 'zombie#home'
  match '/about', to: 'zombie#about', via: 'get'
end