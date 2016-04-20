@focus
Feature: Heartbeat

  Background:
    Given I open the wallboard
    Then I should be redirected to login via keycloak
    When I login
    Then I should be connected
    And I have authenticated
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity |
      | one  | 1000          | 10000           |

  Scenario: Wallboard redirects to keycloak
    Given I open the wallboard
    Given I submit a heartbeat with:
      | centre | male_occupied | female_occupied | male_outofcommission | female_outofcommission |
      | one    | 100           | 2000            | 1000                 | 1000                   |
#    And I show the numbers of with id "1"
#    Then the "one" centre shows "100" available "
