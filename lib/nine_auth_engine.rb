# NineAuthEngine

module NineAuthEngine
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
          flash[:error] = I18n.t(NineAuth::Config.signin_required_flash_message, :default => NineAuth::Config.signin_required_flash_message)
          redirect_to new_user_sessions_path
          return false
        end
      end

      def require_no_user
        if current_user
          store_location
          flash[:error] = I18n.t(NineAuth::Config.signout_required_flash_message, :default => NineAuth::Config.signout_required_flash_message)
          redirect_to :back
          return false
        end
      end  
      
    end # /InstanceMethods
  end # /Authentication
end
