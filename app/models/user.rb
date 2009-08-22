class User < ActiveRecord::Base
  
  acts_as_authentic
  
  validates_presence_of :email
  
  def deliver_email_confirmation_instructions!  
    reset_perishable_token!  
    NineAuthMailer.deliver_email_confirmation_instructions(self)  
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    NineAuthMailer.deliver_password_reset_instructions(self)  
  end
  
end