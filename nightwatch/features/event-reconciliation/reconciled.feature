Feature: Reconciled

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
    Given I am on the wallboard

  Scenario: Reconciled Check In Event and Movement In does not show as Unexpected In and Scheduled In or affect Availability
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
      | In           | oneman   | 111     | now     | Removal | 1234          |
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
    And I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    Then The Centre "one" should show the following under "Male":
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


  Scenario: Reconciled Check out Event and Movement out does not show as Unexpected out and Scheduled out or affect Availability
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
      | Out          | oneman   | 111     | now     | Removal | 1234          |
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
    And I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    And I submit the following "check out" event:
      | centre    | one |
      | timestamp | now |
      | person_id | 12  |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Scheduled incoming     | 0    |
      | Scheduled outgoing     | 0    |
      | Unexpected incoming    | 1    |
      | Unexpected outgoing    | 0    |

  Scenario: Check In Event with non-matching CID id does not reconcile
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
      | In           | oneman   | 111     | now     | Removal | 1234          |
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
    And I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 4321 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 999  |
      | Scheduled incoming     | 1    |
      | Scheduled outgoing     | 0    |
      | Unexpected incoming    | 10   |
      | Unexpected outgoing    | 0    |


