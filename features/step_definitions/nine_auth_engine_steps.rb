# Database

Given /^no user exists with an email of "([^\"]*)"$/ do |email|
  User.find_all_by_email(email).should have(0).elements
end

Given /^I am signed up as "([^\"]*)\/([^\"]*)"$/ do |email, password|
  User.create!(:email => email, :password => password, :password_confirmation => password)
end

# Sessions

When /^session is cleared$/ do
  request.reset_session
  controller.instance_variable_set(:@_current_user, nil)
end

# Actions

When /^I sign in( with "remember me")? as "(.*)\/(.*)"$/ do |remember, email, password|
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I check "Remember me"} if remember
  And %{I press "Sign In"}
end

When /^I return next time$/ do
  When %{session is cleared}
  And %{I go to the homepage}
end

When /^I request password reset link to be sent to "(.*)"$/ do |email|
  When %{I go to the password reset request page}
  And %{I fill in "email" with "#{email}"}
  And %{I press "Reset my password"}
end

When /^I update my password with "(.*)\/(.*)"$/ do |password, confirmation|
  And %{I fill in "password" with "#{password}"}
  And %{I fill in "password confirmation" with "#{confirmation}"}
  And %{I press "Update my password"}
end

When /^I follow the password reset link sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  visit edit_password_path(:id => user.perishable_token)
end

When /^I sign out$/ do
  visit '/signout', :delete
end

Then /^I should be signed out$/ do
  controller.current_user.should be_nil
end

Then /^I should be signed in$/ do
  controller.current_user.should_not be_nil
end

Then /^a password reset message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  sent = ActionMailer::Base.deliveries.first
  
  user.email.should == sent.to.first
  sent.subject.should match /password/i
  sent.body.should match /#{user.perishable_token}/
end

Then /^I should see error messages$/ do
  response.body.should match(/Something went wrong, password not updated/)
end