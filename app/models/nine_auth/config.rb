class NineAuth::Config
  @@host = 'localhost:3000'
  @@reply = 'dontreply@9elements.com'

  @@signup_path = '/'
  @@signup_success_flash_message = 'Successfully signed up - please check your email.'
  @@signup_error_flash_message = 'Signup failed. Please correct the errors.'

  @@signin_path = '/'
  @@signin_success_flash_message = 'Successfully signin.'
  @@signin_error_flash_message = 'The signin failed. Please check usernamen and password.'

  @@signout_path = '/'
  @@signout_flash_message = 'Successfully signout.'
  
  @@update_success_flash_message = "Profile succesfully updated."
  
  @@password_reset_path = '/'
  @@password_reset_success_flash_message = "Instructions to reset your password have been emailed to "
  @@password_reset_error_flash_message = "No user was found with that email address"
  @@password_reset_mail_subject = "Password reset instructions"

  @@password_update_path = '/profile'
  @@password_update_success_flash_message = "Password successfully updated"
  @@password_update_error_flash_message = "Something went wrong, password not updated"
  
  @@password_wrong_toker_error_message = "We're sorry, but we could not locate your account." +
    "If you are having issues try copying and pasting the URL " +
    "from your email into your browser or restarting the " +
    "reset password process."
    
  @@signin_required_flash_message = "You must be logged in to access this page"
  @@signout_required_flash_message = "You must be logged out to access this page"
  
  cattr_accessor :host, :reply,
                 :signup_path, :signup_success_flash_message, :signup_error_flash_message,
                 :signin_path, :signin_success_flash_message, :signin_error_flash_message,
                 :signout_path, :signout_flash_message,
                 :update_success_flash_message,
                 :password_reset_path, :password_reset_success_flash_message, :password_reset_error_flash_message, :password_reset_mail_subject,
                 :password_update_path, :password_update_success_flash_message, :password_update_error_flash_message,
                 :password_wrong_toker_error_message,
                 :signin_required_flash_message, :signout_required_flash_message
                 
  def self.layout(layout_name)
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