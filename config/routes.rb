Rails.application.routes.draw do
  get '/' => 'welcome#all_data'
  patch '/notes/move' => 'notes#move'
  resources :folders, param: :title
  resources :notes, param: :title
end
