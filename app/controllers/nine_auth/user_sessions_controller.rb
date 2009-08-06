class NineAuth::UserSessionsController < ApplicationController
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    
    # we define save as a block. it is
    # important for later injection of openid or other 
    # authentication providers
    # (as seen on railscasts)
    @user_session.save do |result|
      if result
        flash[:success] = I18n.t(NineAuth::Config.signin_success_flash_message, :default => NineAuth::Config.signin_success_flash_message)
        redirect_to NineAuth::Config.signin_path
      else
        flash[:error] = I18n.t(NineAuth::Config.signin_error_flash_message, :default => NineAuth::Config.signin_error_flash_message)
        render :action => 'new'
      end
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:success] = I18n.t(NineAuth::Config.signout_flash_message, :default => NineAuth::Config.signout_flash_message)
    redirect_to NineAuth::Config.signout_path
  end

end
