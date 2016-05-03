Feature: Unreconciled Movements

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
    Given I am on the wallboard

  Scenario: Unreconciled Out Movement shows as Scheduled Outgoing and does not affect Availability
    Given The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Scheduled incoming     | 0    |
      | Scheduled outgoing     | 0    |
      | Unexpected incoming    | 0    |
      | Unexpected outgoing    | 0    |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111     | now     | Removal | 1             |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Scheduled incoming     | 0    |
      | Scheduled outgoing     | 1    |
      | Unexpected incoming    | 0    |
      | Unexpected outgoing    | 0    |

  Scenario: Unreconciled In Movement shows as Scheduled incoming and reduces availability
    Given The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Scheduled incoming     | 0    |
      | Scheduled outgoing     | 0    |
      | Unexpected incoming    | 0    |
      | Unexpected outgoing    | 0    |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | In          | oneman   | 111     | now     | Removal | 1             |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 999  |
      | Scheduled incoming     | 1    |
      | Scheduled outgoing     | 0    |
      | Unexpected incoming    | 0    |
      | Unexpected outgoing    | 0    |
