Feature: Wallboard login redirect

  Scenario: Wallboard redirects to keycloak
    Given I am an unauthenticated user
    And I am on the wallboard
    Then I should be redirected to login via keycloak
    When I login
    Then I should be connected
    When I have authenticated
