Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ja/ do
    root 'pages#index'
    get :login, :press, :space, :training, :about, :members, :contacts, :faq, :sitemap, :camp, controller: :pages
    resources :posts, only: %i[index show]
    resources :courses, path: :talks, only: %i[index show]
    resources :contacts, only: :create
    resources :showcases, only: :index
    get 'courses/:id', to: redirect('/talks/%{id}')
    get 'courses', to: redirect('/talks')
    post 'rental/calculate'

    Settings.alias.each do |path|
      get path.from, to: redirect(path.to)
    end
  end

  get Settings.admin_path_prefix, to: "admin#dashboard", as: :admin_root
  # back
  namespace :admin, path: Settings.admin_path_prefix do
    get :space_price
    resources :posts do
      put :sort, on: :collection
      get :preview, on: :member
    end
    resources :courses, :authors, :speakers, :faqs, :categories, :showcases, :videos, :interview_questions do
      put :sort, on: :collection
    end
    resources :index_pictures, :camp_settings
    resources :camp_settings do
      get :preview
      patch :active
    end
    resources :translations, only: %i[index create update]
  end

  # plugins
  resources :redactor_images, only: :create
end
