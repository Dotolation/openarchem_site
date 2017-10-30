Rails.application.routes.draw do
  
  mount Blacklight::Engine => '/'
  Blacklight::Marc.add_routes(self)
  root to: "catalog#index"
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get "input_form" => "input_form#index"
  resource :input_form, as: "input_form", path: "/input_form", controller: "input_form"

  get "input_form/samples" => "input_form#samples"
  get "input_form/samples/autocomplete"
  get "input_form/upload"
  get "/populate-plants" => "input_form#plant_select"
  get "/populate-ingredients" => "input_form#ingredient_select"
  get "input_form/sites" => "input_form#site_select"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
