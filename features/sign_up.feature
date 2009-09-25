Feature: Sign up
  In order to get access to protected sections of the site
  A user
  Should be able to sign up

    Scenario: User signs up with invalid data
      When I go to the sign up page
      And I fill in "Email" with "invalidemail"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with ""
      And I press "Sign In"
      Then I should see "Please correct the following errors and try again"
	  And I should see "Password confirmation is too short (minimum is 4 characters)"
	  And I should see "Password doesn't match confirmation"
	  And I should see "Email should look like an email address"

    Scenario: User signs up with valid data
      When I go to the sign up page
      And I fill in "Email" with "vrame@9elements.com"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with "password"
      And I press "Sign In"
      Then I should not see "Please correct the following errors and try again"
