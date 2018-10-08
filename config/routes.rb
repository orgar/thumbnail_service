Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'thumbnail', to: 'thumbnails#ipad_thumbnail' , as: :thumbnail
end
