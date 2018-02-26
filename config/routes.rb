Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  	resources :callbacks do
        collection do
          post 'image_upload_callback'
        end
    end
    resources :images


	scope module: 'mobile' do

		resources :articles
		
		root 'home#index'
		resources :plaser
		# namespace :mobile do 
		# 	root 'home#index'
		# end
	end
end
