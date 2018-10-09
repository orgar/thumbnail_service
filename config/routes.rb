Rails.application.routes.draw do

  # Routing to validate the server is alive
  root :to => 'thumbnails#is_alive'
  get 'active', to: 'thumbnails#is_alive'

  # get thumbnail 
  get 'thumbnail', to: 'thumbnails#ipad_thumbnail' , as: :thumbnail
end
