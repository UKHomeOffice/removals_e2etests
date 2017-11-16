@cancret
Feature: NON-OCC move when a return move is cancelled.
  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | one woman       |
    And The following detainee exists:
      | centre      | one      |
      | cid_id      | 1433     |
      | person_id   | 1234     |
      | gender      | m        |
      | nationality | abc      |
    And I am on the wallboard
    Then The Centre "one" should show the following under "Male":
      | In use              | 0     |
      | Out of commission   | 0     |
      | Contingency         | 0     |
      | Prebooked           | 0     |
      | Estimated available | 1000  |
      | Outgoing            | 0     |

  Scenario: NON-OCC move is set with return (two movements are generated).
    When I submit the following movements:

      | MO In/MO Out | Location  | MO Ref | MO Date | MO Type       | CID Person ID |
      | Out          | oneman    | 111    | now     | Non-Occupancy | 1433          |
      | In           | oneman    | 112    | now     | Non-Occupancy | 1433          |
    Then The Centre "one" should show the following under "Male":
      | Estimated available | 1000  |
      | Incoming            | 0     |
      | Outgoing            | 0     |

  Scenario: Detainee is moved to location on first movement.

     When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | Out           | oneman   | 113    | now     | Non-occupancy | 1433       |
    Then The Centre "one" should show the following under "Male":
      | Estimated available | 1000 |
      | Incoming            | 0    |
      | Outgoing            | 1    |