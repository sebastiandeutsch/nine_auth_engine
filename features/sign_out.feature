Feature: Sign out
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out

    Scenario: User signs out
      Given I am signed up as "vrame@9elements.com/password"
      When I sign in as "vrame@9elements.com/password"
      Then I should be signed in
      And I sign out
      Then I should see "Successfully signed out."
      And I should be signed out

    Scenario: User who was remembered signs out
      Given I am signed up as "vrame@9elements.com/password"
      When I sign in with "remember me" as "vrame@9elements.com/password"
      Then I should be signed in
      And I sign out
      Then I should see "Successfully signed out."
      And I should be signed out
      When I return next time
      Then I should be signed out

