class NineAuth::PasswordsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:success] = "#{I18n.t(NineAuthEngine.configuration.password_reset_success_flash_message, :default => NineAuthEngine.configuration.password_reset_success_flash_message)} #{@user.email}" 
      redirect_to NineAuthEngine.configuration.password_reset_path
    else
      flash[:error] = I18n.t(NineAuthEngine.configuration.password_reset_error_flash_message, :default => NineAuthEngine.configuration.password_reset_error_flash_message)
      render :action => :new
    end
  end
  
  def edit
  end
 
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:success] = I18n.t(NineAuthEngine.configuration.password_update_success_flash_message, :default => NineAuthEngine.configuration.password_update_success_flash_message)
      redirect_to NineAuthEngine.configuration.password_update_path
    else
      flash[:error] = I18n.t(NineAuthEngine.configuration.password_update_error_flash_message, :default => NineAuthEngine.configuration.password_update_error_flash_message)
      render :action => :edit
    end
  end
 
  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:error] = I18n.t(NineAuthEngine.configuration.password_wrong_toker_error_flash_message, :default => NineAuthEngine.configuration.password_wrong_toker_error_flash_message)
        redirect_to :action => :new
      end
    end
end