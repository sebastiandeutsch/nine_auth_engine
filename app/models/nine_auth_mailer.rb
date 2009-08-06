class NineAuthMailer < ActionMailer::Base
  default_url_options[:host] = "#{NineAuth::Config.host}"
  
  
  def password_reset_instructions(user)
    subject       NineAuth::Config.password_reset_mail_subject
    from          "<#{NineAuth::Config.reply}>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_url(user.perishable_token)
  end  

end