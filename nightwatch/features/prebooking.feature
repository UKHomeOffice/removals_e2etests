Feature: Prebooking

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
    Given I am on the wallboard

  Scenario: Prebooking updates the wallboard
    When I submit the following prebookings:
      | task_force | location | cid_id |
      | john       | oneman   |        |
      | jack       | onebman  |        |
      | jane       | onewoman |        |
      | foo        | oneman   | 7000   |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Prebookings            | 3    |
      | Availability           | 997  |
      | Scheduled outgoing     | 0    |
      | Scheduled incoming     | 0    |
    Then The Centre "one" should show the following under "Female":
      | Contractual Capacity   | 10000 |
      | Occupied               | 0     |
      | Beds out of commission | 0     |
      | Prebookings            | 1     |
      | Availability           | 9999  |
      | Scheduled outgoing     | 0     |
      | Scheduled incoming     | 0     |

  Scenario: Prebooking is reconciled with a movement with movement first
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 991     | now     | Removal | 1399          |
    When I submit the following prebookings:
      | task_force | location | cid_id |
      | foo        | oneman   | 1399   |
      | foo        | oneman   |        |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Prebookings            | 1    |
      | Availability           | 999  |
      | Scheduled outgoing     | 0    |
      | Scheduled incoming     | 1    |

  Scenario: Prebooking is reconciled with a movement with prebooking first
    When I submit the following prebookings:
      | task_force | location | cid_id |
      | foo        | oneman   | 1299   |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111     | now     | Removal | 1299          |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Scheduled outgoing     | 0    |
      | Scheduled incoming     | 1    |