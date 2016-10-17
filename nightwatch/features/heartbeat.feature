Feature: Heartbeat

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity |
      | one  | 1000          | 10000           |
      | two  | 2000          | 20000           |

  Scenario: Heartbeat updates the wallboard
    Given I am on the wallboard
    Then The Centre "one" should show the following under "Male":
      | In use              | 0    |
      | Out of commission   | 0    |
      | Prebooked           | 0    |
      | Estimated available | 1000 |
      | Outgoing            | 0    |
    And The Centre "one" should show the following under "Female":
      | In use              | 0     |
      | Out of commission   | 0     |
      | Prebooked           | 0     |
      | Estimated available | 10000 |
      | Outgoing            | 0     |
    When I submit a heartbeat with:
      | centre                 | one  |
      | male_occupied          | 100  |
      | female_occupied        | 2000 |
      | male_outofcommission   | 2000 |
      | female_outofcommission | 3000 |
    Then The Centre "one" should show the following under "Male":
      | In use              | 100   |
      | Out of commission   | 2000  |
      | Prebooked           | 0     |
      | Estimated available | -1100 |
      | Outgoing            | 0     |
    And The Centre "one" should show the following under "Female":
      | In use              | 2000 |
      | Out of commission   | 3000 |
      | Prebooked           | 0    |
      | Estimated available | 5000 |
      | Outgoing            | 0    |
    And the Centre "one" should show "0" Unexpected "Female" Check-ins
