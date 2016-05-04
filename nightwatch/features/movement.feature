Feature: Movement

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |

  Scenario: Movements updates the wallboard
    Given I am on the wallboard
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type       | CID Person ID |
      | In           | oneman   | 111     | now     | Removal       | 1             |
      | In           | onebman  | 112     | now     | Occupancy     | 2             |
      | In           | oneman   | 113     | now     | Non-Occupancy | 3             |
      | Out          | onewoman | 114     | now     | Removal       | 4             |
      | Out          | onewoman | 115     | now     | Occupancy     | 5             |
      | Out          | onewoman | 116     | now     | Non-Occupancy | 6             |

    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Prebookings            | 0    |
      | Availability           | 998  |
      | Scheduled outgoing     | 0    |
      | Scheduled incoming     | 2    |
    Then The Centre "one" should show the following under "Female":
      | Contractual Capacity   | 10000 |
      | Occupied               | 0     |
      | Beds out of commission | 0     |
      | Prebookings            | 0     |
      | Availability           | 10000 |
      | Scheduled outgoing     | 2     |
      | Scheduled incoming     | 0     |
