Feature: Sanity Checks

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
      | two  | 2000          | 20000           | twoman,twobman | twowoman        |
    And I am on the wallboard
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Expected incoming      | 0    |
      | Expected outgoing      | 0    |
      | Unexpected incoming    | 0    |
    And The Centre "one" should show the following under "Female":
      | Contractual Capacity   | 10000 |
      | Occupied               | 0     |
      | Beds out of commission | 0     |
      | Contingency            | 0     |
      | Prebookings            | 0     |
      | Availability           | 10000 |
      | Expected incoming      | 0     |
      | Expected outgoing      | 0     |
      | Unexpected incoming    | 0     |
    And The Centre "two" should show the following under "Male":
      | Contractual Capacity   | 2000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 2000 |
      | Expected incoming      | 0    |
      | Expected outgoing      | 0    |
      | Unexpected incoming    | 0    |
    And The Centre "two" should show the following under "Female":
      | Contractual Capacity   | 20000 |
      | Occupied               | 0     |
      | Beds out of commission | 0     |
      | Contingency            | 0     |
      | Prebookings            | 0     |
      | Availability           | 20000 |
      | Expected incoming      | 0     |
      | Expected outgoing      | 0     |
      | Unexpected incoming    | 0     |

  Scenario: Centre one's events shouldn't affect Centre two, male shouldn't affect female
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111    | now     | Removal | 1234          |
      | In           | onewoman | 222    | now     | Removal | 4321          |
      | In           | onewoman | 333    | now     | Removal | 5432          |
    Then The Centre "one" should show the following under "Male":
      | Availability      | 999 |
      | Expected incoming | 1   |
    And The Centre "one" should show the following under "Female":
      | Availability      | 9998 |
      | Expected incoming | 2    |
    And The Centre "two" should show the following under "Male":
      | Availability      | 2000 |
      | Expected incoming | 0    |
    And The Centre "two" should show the following under "Female":
      | Availability      | 20000 |
      | Expected incoming | 0     |
    When I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    And I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 4321 |
      | person_id   | 21   |
      | gender      | f    |
      | nationality | abc  |
    And I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 5432 |
      | person_id   | 32   |
      | gender      | f    |
      | nationality | abc  |
    Then The Centre "one" should show the following under "Male":
      | Availability      | 1000 |
      | Expected incoming | 0    |
    And The Centre "one" should show the following under "Female":
      | Availability      | 10000 |
      | Expected incoming | 0     |
    And The Centre "two" should show the following under "Male":
      | Availability      | 2000 |
      | Expected incoming | 0    |
    And The Centre "two" should show the following under "Female":
      | Availability      | 20000 |
      | Expected incoming | 0     |

