class NineAuth::Backend::UsersController < ApplicationController
  before_filter :require_admin
  
  def new
    @user = User.new
  end
  
  def index
    @users = User.find(:all)  
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user
      @user.destroy
      redirect_to :action => 'index'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
    
  def create
    @user = User.new(params[:user])
    
    # @todo save as block
    # but as of writing this 06.08.09 authlogic is broken
    if @user.save
        @user.deliver_account_created_instructions(params[:user][:password]) if params[:send_mail] == "1"
        flash[:success] = I18n.t(NineAuthEngine.configuration.create_user_success_flash_message, :default => NineAuthEngine.configuration.create_user_success_flash_message)
        redirect_to backend_users_path
    else
      flash[:error] = I18n.t(NineAuthEngine.configuration.create_user_error_flash_message, :default => NineAuthEngine.configuration.create_user_error_flash_message)
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    # @todo save as block
    # but as of writing this 06.08.09 authlogic is broken
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = I18n.t(NineAuthEngine.configuration.update_success_flash_message, :default => NineAuthEngine.configuration.update_success_flash_message)
      redirect_to backend_users_path
    else
      render :action => 'edit'
    end
  end
end
