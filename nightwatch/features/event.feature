Feature: Unreconciled Events

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
    Given I am on the wallboard
    And The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Expected incoming      | 0    |
      | Expected outgoing      | 0    |
      | Unexpected incoming    | 0    |

  Scenario: Unreconciled Check In Event shows as Unexpected Incoming and does not affect Availability
    Given I submit the following "check in" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Expected incoming      | 0    |
      | Expected outgoing      | 0    |
      | Unexpected incoming    | 1    |
    And the Centre "one" should show the following CIDS under "Male" "Unexpected incoming", which should be clickable:
      | CID Person ID |
      | 999999        |

  Scenario: Update changes gender
    Given I submit the following "check in" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Then The Centre "one" should show the following under "Male":
      | Unexpected incoming | 1 |
    And I submit the following "update individual" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | f      |
      | nationality | abc    |
    Then The Centre "one" should show the following under "Male":
      | Unexpected incoming | 0 |

