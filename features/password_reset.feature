Feature: Password reset
  In order to sign in even if user forgot their password
  A user
  Should be able to reset it

    Scenario: User is not signed up
      Given no user exists with an email of "vrame@9elements.com"
      When I request password reset link to be sent to "vrame@9elements.com"
      Then I should see "No user was found with that email address"

    Scenario: User is signed up and requests password reset
      Given I am signed up as "vrame@9elements.com/password"
      When I request password reset link to be sent to "vrame@9elements.com"
      Then I should see "Instructions to reset your password have been emailed to vrame@9elements.com"
      And a password reset message should be sent to "vrame@9elements.com"

    Scenario: User is signed up updated his password and types wrong confirmation
      Given I am signed up as "vrame@9elements.com/password"
      When I follow the password reset link sent to "vrame@9elements.com"
      And I update my password with "newpassword/wrongconfirmation"
      Then I should see error messages
      And I should be signed out

    Scenario: User is signed up and updates his password
      Given I am signed up as "vrame@9elements.com/password"
      When I follow the password reset link sent to "vrame@9elements.com"
      And I update my password with "newpassword/newpassword"
      Then I should be signed in
      When I sign out
      Then I should be signed out
      And I sign in as "vrame@9elements.com/newpassword"
      Then I should be signed in

