Feature: Reconciled Check In/Out Events

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
      | two  | 1000          | 10000           | twoman,twobman | twowoman        |
    And I am on the wallboard
    And The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Scheduled incoming     | 0    |
      | Scheduled outgoing     | 0    |
      | Unexpected incoming    | 0    |

  Scenario: Reconciled Check In Event and Movement In does not show as Unexpected In and Scheduled In or affect Availability
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111     | now     | Removal | 1234          |
    Then The Centre "one" should show the following under "Male":
      | Availability       | 999 |
      | Scheduled incoming | 1   |
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

  Scenario: Reconciled Check out Event and Movement out does not show as Scheduled out or affect Availability
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111     | now     | Removal | 1234          |
    And The following detainee exists:
      | centre      | one  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    Then The Centre "one" should show the following under "Male":
      | Availability       | 1000 |
      | Scheduled outgoing | 1    |
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
      | Unexpected incoming    | 0    |

  Scenario: Update changes cid_id
    Given I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111     | now     | Removal | 999999        |
    When I submit the following "check in" event:
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
      | Scheduled incoming     | 0    |
      | Scheduled outgoing     | 0    |
      | Unexpected incoming    | 0    |
    When I submit the following "update individual" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 111111 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Then The Centre "one" should show the following under "Male":
      | Unexpected incoming | 1 |
      | Scheduled incoming  | 1 |

  Scenario: Inter Site Transfer (movement first)
    Given The following detainee exists:
      | centre      | one    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111     | now     | Removal | 999999        |
      | In           | twoman   | 222     | now     | Removal | 999999        |
    Then The Centre "one" should show the following under "Male":
      | Scheduled outgoing | 1 |
    And The Centre "two" should show the following under "Male":
      | Unexpected incoming | 0 |
      | Scheduled incoming  | 1 |
    When I submit the following "inter site transfer" event:
      | centre    | one   |
      | centre_to | two   |
      | timestamp | now   |
      | person_id | 12    |
      | reason    | Other |
    Then The Centre "one" should show the following under "Male":
      | Scheduled outgoing | 0 |
    And The Centre "two" should show the following under "Male":
      | Unexpected incoming | 0 |
      | Scheduled incoming  | 0 |

  Scenario: Inter Site Transfer (event first)
    Given The following detainee exists:
      | centre      | one    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    When I submit the following "inter site transfer" event:
      | centre    | one   |
      | centre_to | two   |
      | timestamp | now   |
      | person_id | 12    |
      | reason    | Other |
    And The Centre "two" should show the following under "Male":
      | Unexpected incoming | 1 |
      | Scheduled incoming  | 0 |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111     | now     | Removal | 999999        |
      | In           | twoman   | 222     | now     | Removal | 999999        |
    Then The Centre "one" should show the following under "Male":
      | Scheduled outgoing | 0 |
    And The Centre "two" should show the following under "Male":
      | Unexpected incoming | 0 |
      | Scheduled incoming  | 0 |

  Scenario: Inter Site Transfer (before checkin/detainee exists)
    Given The following centres exist:
      | name | male_capacity |
      | two  | 1000          |
    When I submit the following "inter site transfer" event:
      | centre    | one   |
      | centre_to | two   |
      | timestamp | now   |
      | person_id | 12    |
      | reason    | Other |
    And I submit the following "check in" event:
      | centre      | one    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    And The Centre "two" should show the following under "Male":
      | Unexpected incoming | 1 |
      | Scheduled incoming  | 0 |
