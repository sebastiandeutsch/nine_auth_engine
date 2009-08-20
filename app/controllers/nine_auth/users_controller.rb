class NineAuth::UsersController < ApplicationController
  
  before_filter :require_user, :only => [:show, :edit]
  
  def new
    @user = User.new
  end
  
  def show
    @user = current_user
  end
  
  def create
    @user = User.new(params[:user])
    
    # @todo save as block
    # but as of writing this 06.08.09 authlogic is broken
    if @user.save
      flash[:success] = I18n.t(NineAuthEngine.configuration.signup_success_flash_message, :default => NineAuthEngine.configuration.signup_success_flash_message)
      redirect_to NineAuthEngine.configuration.signup_path
    else
      flash[:success] = I18n.t(NineAuthEngine.configuration.signup_error_flash_message, :defaukt => NineAuthEngine.configuration.signup_error_flash_message)
      render :action => 'new'
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
  
end
