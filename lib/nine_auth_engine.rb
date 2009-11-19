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
                  :after_signup_redirect, :signup_success_flash_message, :signup_error_flash_message,
                  :after_signup_disabled_redirect, :signup_disabled_flash_message,
                  :after_signin_redirect, :signin_success_flash_message, :signin_error_flash_message,
                  :after_signout_redirect, :signout_flash_message,
                  :update_success_flash_message,
                  :after_password_reset_redirect, :password_reset_success_flash_message, :password_reset_error_flash_message, :password_reset_mail_subject,
                  :after_password_update_redirect, :password_update_success_flash_message, :password_update_error_flash_message,
                  :password_wrong_token_error_flash_message,
                  :signin_required_flash_message, :signout_required_flash_message,
                  :admin_rights_required_flash_message,
                  :email_confirmation_mail_subject, :email_confirmation_success_flash_message, :email_confirmation_error_flash_message,
                  :create_user_success_flash_message, :create_user_error_flash_message,
                  :layout, :double_opt_in, :disable_signup,
                  :backend_namespace,
                  :account_created_mail_subject
                  
    def initialize()  
      @host = 'localhost:3000'
      @reply = 'dontreply@9elements.com'
      
      @layout = ''
      @double_opt_in = true
      @disable_signup = false

      @after_signup_redirect = '/'
      @signup_success_flash_message = 'Successfully signed up - please check your email.'
      @signup_error_flash_message = 'Sign up failed. Please correct the errors.'

      @after_signup_disabled_redirect = '/'
      @signup_disabled_flash_message = 'The sign up is disabled.'

      @after_signin_redirect = '/'
      @signin_success_flash_message = 'Successfully signed in.'
      @signin_error_flash_message = 'Sign in failed. Please check username and password.'

      @after_signout_redirect = '/'
      @signout_flash_message = 'Successfully signed out.'

      @update_success_flash_message = "Profile succesfully updated."

      @after_password_reset_redirect = '/'
      @password_reset_success_flash_message = "Instructions to reset your password have been emailed to "
      @password_reset_error_flash_message = "No user was found with that email address"
      @password_reset_mail_subject = "Password reset instructions"
      
      @email_confirmation_mail_subject = "Email confirmation"
      @email_confirmation_success_flash_message = "Your email has been verified"
      @email_confirmation_error_flash_message = "Something went wrong - Your email has not been verified"
      @account_created_mail_subject = "Your account has been created"
      
      @after_password_update_redirect = '/profile'
      @password_update_success_flash_message = "Password successfully updated"
      @password_update_error_flash_message = "Something went wrong, password not updated"

      @password_wrong_token_error_flash_message = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."

      @signin_required_flash_message = "You must be logged in to access this page"
      @signout_required_flash_message = "You must be logged out to access this page"
      
      @admin_rights_required_flash_message = "You must have admin rights to access this page"
      
      @create_user_success_flash_message = "The user has been successfully created."
      @create_user_error_flash_message = "Could not create user. Please correct the errors."
      
      @backend_namespace = "backend"
    end    
    
    def layout(layout_name)
      @layout = layout_name
      
      NineAuth::PasswordsController.class_eval do
        layout layout_name
      end

      NineAuth::UserSessionsController.class_eval do
        layout layout_name
      end

      NineAuth::UsersController.class_eval do
        layout layout_name
      end
      
      NineAuth::Backend::UsersController.class_eval do
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
      
      def require_admin
        unless current_user and current_user.admin
          store_location
          flash[:error] = I18n.t(NineAuthEngine.configuration.admin_rights_required_flash_message, :default => NineAuthEngine.configuration.admin_rights_required_flash_message)
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
  
  module User
    def self.included(model)

      model.class_eval do
        acts_as_authentic
        
        if not self.login_field.nil?
          validates_presence_of self.login_field
        end

        validates_presence_of :email
      end

      model.extend(ClassMethods)
      model.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def deliver_email_confirmation_instructions!  
        reset_perishable_token!  
        NineAuthMailer.deliver_email_confirmation_instructions(self)  
      end

      def deliver_password_reset_instructions!  
        reset_perishable_token!  
        NineAuthMailer.deliver_password_reset_instructions(self)  
      end
    end
    
    module ClassMethods
      def find_by_username_or_email(login)
        user = nil
        if not self.login_field.nil?
          user = self.find(:first, :conditions => [ "#{self.login_field} = ?", login]) || self.find_by_email(login)
        else
          user = self.find_by_email(login)
        end
        user
      end
    end
  end
end
