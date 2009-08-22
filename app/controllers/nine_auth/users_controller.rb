class NineAuth::UsersController < ApplicationController
  before_filter :check_if_signup_is_disabled, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit]
  before_filter :load_user_using_perishable_token, :only => [:confirm_email]
  
  def new
    @user = User.new
  end
  
  def show
    @user = current_user
  end
    
  def create
    @user = User.new(params[:user])
    @user.active = false if NineAuthEngine.configuration.double_opt_in
    
    # @todo save as block
    # but as of writing this 06.08.09 authlogic is broken
    if @user.save
      @user.deliver_email_confirmation_instructions! if NineAuthEngine.configuration.double_opt_in
      flash[:success] = I18n.t(NineAuthEngine.configuration.signup_success_flash_message, :default => NineAuthEngine.configuration.signup_success_flash_message)
      redirect_to NineAuthEngine.configuration.signup_path
    else
      flash[:error] = I18n.t(NineAuthEngine.configuration.signup_error_flash_message, :default => NineAuthEngine.configuration.signup_error_flash_message)
      render :action => 'new'
    end
  end
  
  def confirm_email
    @user.active = true
    if @user.save
      flash[:success] = I18n.t(NineAuthEngine.configuration.email_confirmation_success_flash_message, :default => NineAuthEngine.configuration.email_confirmation_success_flash_message)
      redirect_to NineAuthEngine.configuration.password_update_path
    else
      flash[:error] = I18n.t(NineAuthEngine.configuration.email_confirmation_error_flash_message, :default => NineAuthEngine.configuration.email_confirmation_error_flash_message)
      render :action => :edit
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    # @todo save as block
    # but as of writing this 06.08.09 authlogic is broken
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = I18n.t(NineAuthEngine.configuration.update_success_flash_message, :default => NineAuthEngine.configuration.update_success_flash_message)
      redirect_to :action => 'show'
    else
      render :action => 'edit'
    end
  end

private
  def check_if_signup_is_disabled
    if NineAuthEngine.configuration.disable_signup
      flash[:error] = I18n.t(NineAuthEngine.configuration.signup_disabled_flash_message, :default => NineAuthEngine.configuration.signup_disabled_flash_message)
      redirect_to NineAuthEngine.configuration.signup_disabled_path
      false
    else
      true
    end
  end
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = I18n.t(NineAuthEngine.configuration.password_wrong_token_error_flash_message, :default => NineAuthEngine.configuration.password_wrong_token_error_flash_message)
      redirect_to :action => :new
      false
    end
    true
  end
end
