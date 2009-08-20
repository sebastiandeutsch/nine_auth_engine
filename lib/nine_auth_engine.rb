# NineAuthEngine

module NineAuthEngine
  class << self
    # The Configuration instance used to configure the NineAuthEngine
    def configuration
      @@configuration
    end

    def configuration=(configuration)
      @@configuration = configuration
    end

    def configure
      yield NineAuthEngine.configuration if block_given?
    end
  end
  
  class Configuration
    attr_accessor :host, :reply,
                  :signup_path, :signup_success_flash_message, :signup_error_flash_message,
                  :signin_path, :signin_success_flash_message, :signin_error_flash_message,
                  :signout_path, :signout_flash_message,
                  :update_success_flash_message,
                  :password_reset_path, :password_reset_success_flash_message, :password_reset_error_flash_message, :password_reset_mail_subject,
                  :password_update_path, :password_update_success_flash_message, :password_update_error_flash_message,
                  :password_wrong_toker_error_flash_message,
                  :signin_required_flash_message, :signout_required_flash_message
                   
    def initialize()  
      @host = 'localhost:3000'
      @reply = 'dontreply@9elements.com'

      @signup_path = '/'
      @signup_success_flash_message = 'Successfully signed up - please check your email.'
      @signup_error_flash_message = 'Sign up failed. Please correct the errors.'

      @signin_path = '/'
      @signin_success_flash_message = 'Successfully signed in.'
      @signin_error_flash_message = 'Sign in failed. Please check username and password.'

      @signout_path = '/'
      @signout_flash_message = 'Successfully signed out.'

      @update_success_flash_message = "Profile succesfully updated."

      @password_reset_path = '/'
      @password_reset_success_flash_message = "Instructions to reset your password have been emailed to "
      @password_reset_error_flash_message = "No user was found with that email address"
      @password_reset_mail_subject = "Password reset instructions"

      @password_update_path = '/profile'
      @password_update_success_flash_message = "Password successfully updated"
      @password_update_error_flash_message = "Something went wrong, password not updated"

      @password_wrong_toker_error_message = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."

      @signin_required_flash_message = "You must be logged in to access this page"
      @signout_required_flash_message = "You must be logged out to access this page"
    end    
    
    def layout(layout_name)
      NineAuth::PasswordsController.class_eval do
        layout layout_name
      end

      NineAuth::UserSessionsController.class_eval do
        layout layout_name
      end

      NineAuth::UsersController.class_eval do
        layout layout_name
      end
    end
  end
  
  # Instanciate the default configuration and expose several possibilities
  # to override the behavior
  class Initializer    
    def self.run(configuration = Configuration.new)
      yield configuration if block_given?
      NineAuthEngine.configuration = configuration
    end
  end
  
  # run it once, so that we have an configuration instance
  # change the configuration using the configure method
  # NineAuthEngine.configure 
  #  config.host = '123'
  # end
  # in case you want you totally want to change the configuration class
  # just call Initializer.run with a parameter and optionally a block
  Initializer.run
  
  module Authentication

    def self.included(controller)
      controller.send(:include, InstanceMethods)

      controller.class_eval do
        helper_method :current_user_session, :current_user
      end
    end

    module InstanceMethods      
      def store_location
        session[:return_to] = request.request_uri unless request.xhr?
      end
      
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end

      def require_user
        unless current_user
          store_location
          flash[:error] = I18n.t(NineAuthEngine.configuration.signin_required_flash_message, :default => NineAuthEngine.configuration.signin_required_flash_message)
          redirect_to new_user_sessions_path
          return false
        end
      end

      def require_no_user
        if current_user
          store_location
          flash[:error] = I18n.t(NineAuthEngine.configuration.signout_required_flash_message, :default => NineAuthEngine.configuration.signout_required_flash_message)
          redirect_to :back
          return false
        end
      end  
      
    end # /InstanceMethods
  end # /Authentication
end
