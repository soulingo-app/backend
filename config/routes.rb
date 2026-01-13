# config/routes.rb

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      get 'auth/me', to: 'auth#me'

      # Users
      put 'users/recording', to: 'users#update_recording'
      
      # Lessons
      get 'lessons/:module_num/:lesson_num', to: 'lessons#show'
    end
  end

  get 'health', to: 'health#index'
end