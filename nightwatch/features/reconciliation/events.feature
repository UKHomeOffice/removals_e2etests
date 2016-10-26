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
      | In use              | 0    |
      | Out of commission   | 0    |
      | Contingency         | 0    |
      | Prebooked           | 0    |
      | Estimated available | 1000 |
      | Incoming            | 0    |
      | Outgoing            | 0    |
    And the Centre "one" should show "0" Unexpected "Male" Check-ins

  Scenario: Reconciling a Movement In with a Check In event removes it from the Expected Incoming count and CID ID list, and changes the Availability
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date       | MO Type | CID Person ID |
      | In           | oneman   | 111    | 5 minutes ago | Removal | 1234          |
      | In           | oneman   | 211    | now           | Removal | 1235          |
    Then The Centre "one" should show the following under "Male":
      | In use              | 0   |
      | Out of commission   | 0   |
      | Contingency         | 0   |
      | Prebooked           | 0   |
      | Estimated available | 998 |
      | Incoming            | 2   |
      | Outgoing            | 0   |
    And the Centre "one" should show the following CIDS under "Male" "Incoming":
      | CID Person ID |
      | 1234          |
      | 1235          |
    And I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    Then The Centre "one" should show the following under "Male":
      | In use              | 0   |
      | Out of commission   | 0   |
      | Contingency         | 0   |
      | Prebooked           | 0   |
      | Estimated available | 999 |
      | Incoming            | 1   |
      | Outgoing            | 0   |
    And the Centre "one" should show the following CIDS under "Male" "Incoming":
      | CID Person ID |
      | 1235          |
    And the Centre "one" should show "0" Unexpected "Male" Check-ins


  Scenario: Reconciling a Check out Event with a Movement out removes it from the Expected Outgoing count and CID ID list, but does not change the Availability
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date       | MO Type | CID Person ID |
      | Out          | oneman   | 111    | 5 minutes ago | Removal | 1234          |
      | Out          | oneman   | 131    | now           | Removal | 7634          |
    And The following detainee exists:
      | centre      | one  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    Then The Centre "one" should show the following under "Male":
      | In use              | 0    |
      | Out of commission   | 0    |
      | Contingency         | 0    |
      | Prebooked           | 0    |
      | Estimated available | 1000 |
      | Incoming            | 0    |
      | Outgoing            | 2    |
    And the Centre "one" should show the following CIDS under "Male" "Outgoing":
      | CID Person ID |
      | 1234          |
      | 7634          |
    And I submit the following "check out" event:
      | centre    | one |
      | timestamp | now |
      | person_id | 12  |
    Then The Centre "one" should show the following under "Male":
      | In use              | 0    |
      | Out of commission   | 0    |
      | Contingency         | 0    |
      | Prebooked           | 0    |
      | Estimated available | 1000 |
      | Incoming            | 0    |
      | Outgoing            | 1    |
    And the Centre "one" should show the following CIDS under "Male" "Outgoing":
      | CID Person ID |
      | 7634          |

  Scenario: Update changes cid_id
    Given I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111    | now     | Removal | 999999        |
    When I submit the following "check in" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Then The Centre "one" should show the following under "Male":
      | In use              | 0    |
      | Out of commission   | 0    |
      | Contingency         | 0    |
      | Prebooked           | 0    |
      | Estimated available | 1000 |
      | Incoming            | 0    |
      | Outgoing            | 0    |
    And the Centre "one" should show "0" Unexpected "Male" Check-ins
    When I submit the following "update individual" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 111111 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Then The Centre "one" should show the following under "Male":
      | Incoming | 1 |
    And the Centre "one" should show "1" Unexpected "Male" Check-ins

  Scenario: Inter Site Transfer (movement first)
    Given The following detainee exists:
      | centre      | one    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111    | now     | Removal | 999999        |
      | In           | twoman   | 111    | now     | Removal | 999999        |
    Then The Centre "one" should show the following under "Male":
      | Outgoing | 1 |
    And The Centre "two" should show the following under "Male":
      | Incoming | 1 |
    And the Centre "one" should show "0" Unexpected "Male" Check-ins
    When I submit the following "inter site transfer" event:
      | centre    | one   |
      | centre_to | two   |
      | timestamp | now   |
      | person_id | 12    |
      | reason    | Other |
    Then The Centre "one" should show the following under "Male":
      | Outgoing | 0 |
    And The Centre "two" should show the following under "Male":
      | Incoming | 0 |
    And the Centre "two" should show "0" Unexpected "Male" Check-ins

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
    And the Centre "two" should show "1" Unexpected "Male" Check-ins
    And The Centre "two" should show the following under "Male":
      | Incoming | 0 |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111    | now     | Removal | 999999        |
      | In           | twoman   | 111    | now     | Removal | 999999        |
    Then The Centre "one" should show the following under "Male":
      | Outgoing | 0 |
    And the Centre "two" should show "0" Unexpected "Male" Check-ins
    And The Centre "two" should show the following under "Male":
      | Incoming | 0 |

  Scenario: Inter Site Transfer (event first, w/o detainee)
    When I submit the following "inter site transfer" event expecting a "422" error:
      | centre    | one   |
      | centre_to | two   |
      | timestamp | now   |
      | person_id | 12    |
      | reason    | Other |

  Scenario: Check In event before Movement reconciliation window doesn't reconcile
    When I submit the following "check in" event:
      | centre      | one        |
      | timestamp   | 5 days ago |
      | cid_id      | 1234       |
      | person_id   | 12         |
      | gender      | m          |
      | nationality | abc        |
    And I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111    | now     | Removal | 1234          |
    Then The Centre "one" should show the following under "Male":
      | Estimated available | 999 |
      | Incoming            | 1   |

  Scenario: Check In event after Movement reconciliation window doesn't reconcile
    When I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    And I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date    | MO Type | CID Person ID |
      | In           | oneman   | 111    | 4 days ago | Removal | 1234          |
    And the Centre "one" should show "1" Unexpected "Male" Check-ins

  Scenario: Early Check In event does reconcile
    When I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    And the Centre "one" should show "1" Unexpected "Male" Check-ins
    And I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date  | MO Type | CID Person ID |
      | In           | oneman   | 111    | tomorrow | Removal | 1234          |
    And the Centre "one" should show "0" Unexpected "Male" Check-ins

  Scenario: Too Early Check In event doesn't reconcile
    When I submit the following "check in" event:
      | centre      | one  |
      | timestamp   | now  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    And I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date         | MO Type | CID Person ID |
      | In           | oneman   | 111    | 4 days from now | Removal | 1234          |
    And the Centre "one" should show "1" Unexpected "Male" Check-ins

