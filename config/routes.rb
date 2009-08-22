ActionController::Routing::Routes.draw do |map|
  # authlogic
  map.resources :users,                        :controller => 'nine_auth/users'
  map.resource  :user_sessions,                :controller => 'nine_auth/user_sessions', :only => [ :new, :create, :destroy ]
  
  map.resources :passwords,                    :controller => 'nine_auth/passwords'
  
  map.signup             'signup',                 :controller => 'nine_auth/users', :action => 'new'
  map.profile            'profile',                :controller => 'nine_auth/users', :action => 'show'
  map.email_confirmation 'email_confirmation/:id', :controller => 'nine_auth/users', :action => 'email_confirmation'
  
  map.forgotten_password 'forgotten_password', :controller => 'nine_auth/passwords',     :action => 'new'

  map.signin  'signin',                        :controller => 'nine_auth/user_sessions', :action => 'new'
  map.signout 'signout',                       :controller => 'nine_auth/user_sessions', :action => 'destroy'
end