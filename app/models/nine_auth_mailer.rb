class NineAuthMailer < ActionMailer::Base
  default_url_options[:host] = "#{NineAuthEngine.configuration.host}"

  def email_confirmation_instructions(user)
    subject       NineAuthEngine.configuration.email_confirmation_mail_subject
    from          "<#{NineAuthEngine.configuration.reply}>"
    recipients    user.email
    sent_on       Time.now
    body          :email_confirmation_url => email_confirmation_url(user.perishable_token)
  end  
    
  def password_reset_instructions(user)
    subject       NineAuthEngine.configuration.password_reset_mail_subject
    from          "<#{NineAuthEngine.configuration.reply}>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_url(user.perishable_token)
  end
end