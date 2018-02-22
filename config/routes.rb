Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	scope module: 'mobile' do
		root 'home#index'
		# namespace :mobile do 
		# 	root 'home#index'
		# end
	end
end
