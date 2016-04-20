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
      | two  | 2000          | 20000           |

  Scenario: Heartbeat updates the wallboard
    Given I open the wallboard
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Scheduled outgoing     | 0    |
      | Scheduled incoming     | 0    |
    Then The Centre "one" should show the following under "Female":
      | Contractual Capacity   | 10000 |
      | Occupied               | 0     |
      | Beds out of commission | 0     |
      | Prebookings            | 0     |
      | Availability           | 10000 |
      | Scheduled outgoing     | 0     |
      | Scheduled incoming     | 0     |
    When I submit a heartbeat with:
      | centre                 | one  |
      | male_occupied          | 100  |
      | female_occupied        | 2000 |
      | male_outofcommission   | 2000 |
      | female_outofcommission | 3000 |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000  |
      | Occupied               | 100   |
      | Beds out of commission | 2000  |
      | Prebookings            | 0     |
      | Availability           | -1100 |
      | Scheduled outgoing     | 0     |
      | Scheduled incoming     | 0     |
    Then The Centre "one" should show the following under "Female":
      | Contractual Capacity   | 10000 |
      | Occupied               | 2000  |
      | Beds out of commission | 3000  |
      | Prebookings            | 0     |
      | Availability           | 5000  |
      | Scheduled outgoing     | 0     |
      | Scheduled incoming     | 0     |
