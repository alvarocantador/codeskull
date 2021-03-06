Rails.application.routes.draw do

  scope "(:locale)", locale: /pt-BR|en/ do
    
    root 'dashboard#index'
    
    get '/login' => 'welcome#index' , as: 'root_login'
    
    devise_for :users

    resources :users do
      resources :grades do
        resources :activities
      end
    end

    get '/tracks/:id/export', to: 'tracks#export'
    resources :tracks do
    	resources :tasks do
        resources :expectations
      end
    end
    
    resources :contents, only: [ :destroy ]

    resources :sandbox, only: [ :show, :update ]
    
  end

end
