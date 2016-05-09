Feature: Wallboard login redirect

  Scenario: Wallboard redirects to keycloak
    Given I am an unauthenticated user
    And I am on the wallboard
    Then I should be redirected to login via keycloak
    When I login
    Then I should be connected

  Scenario: Wallboard has link to update keycloak
    Given I am a logged in user
    And I am on the wallboard
    When I click on the keycloak update link
    Then I should be able to see the keycloak update page
