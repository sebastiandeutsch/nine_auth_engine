Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Scenario: User is not signed up
      Given no user exists with an email of "vrame@9elements.com"
      When I go to the sign in page
      And I sign in as "vrame@9elements.com/password"
      Then I should see "Sign in failed. Please check username and password."
      And I should be signed out

	Scenario: User enters wrong password
	   Given I am signed up as "vrame@9elements.com/password"
	   When I go to the sign in page
	   And I sign in as "vrame@9elements.com/wrongpassword"
	   Then I should see "Sign in failed. Please check username and password."
	   And I should be signed out

	Scenario: User signs in successfully
	   Given I am signed up as "vrame@9elements.com/password"
	   When I go to the sign in page
	   And I sign in as "vrame@9elements.com/password"
	   Then I should see "Successfully signed in."
	   And I should be signed in

	Scenario: User signs in and checks "remember me"
	   Given I am signed up as "vrame@9elements.com/password"
	   When I go to the sign in page
	   And I sign in with "remember me" as "vrame@9elements.com/password"
	   Then I should see "Successfully signed in."
	   And I should be signed in
	   When I return next time
	   Then I should be signed in

