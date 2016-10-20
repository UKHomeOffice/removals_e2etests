Feature: Unreconciled Events

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
    Given I am on the wallboard
    And The Centre "one" should show the following under "Male":
      | In use              | 0    |
      | Out of commission   | 0    |
      | Contingency         | 0    |
      | Prebooked           | 0    |
      | Estimated available | 1000 |
      | Reserved            | 0    |
      | Outgoing            | 0    |
    And the Centre "one" should show "0" Unexpected "Male" Check-ins

  Scenario: Unreconciled Check In Event shows as Unexpected Incoming and does not affect Estimated available
    Given I submit the following "check in" event:
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
      | Reserved            | 0    |
      | Outgoing            | 0    |
    And the Centre "one" should show the following "1" Unexpected "Male" Check-ins:
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
    Then the Centre "one" should show the following "1" Unexpected "Male" Check-ins:
      | CID Person ID |
      | 999999        |
    And I submit the following "update individual" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | f      |
      | nationality | abc    |
    Then the Centre "one" should show "0" Unexpected "Male" Check-ins

  Scenario: Only Check ins within the reconciliation window show on the dashboard
    Given I submit the following "check in" event:
      | centre      | one                  |
      | timestamp   | three days ago 23:30 |
      | cid_id      | 999991               |
      | person_id   | 12                   |
      | gender      | m                    |
      | nationality | abc                  |
    Given I submit the following "check in" event:
      | centre      | one                |
      | timestamp   | two days ago 23:30 |
      | cid_id      | 999992             |
      | person_id   | 12                 |
      | gender      | m                  |
      | nationality | abc                |
    Given I submit the following "check in" event:
      | centre      | one             |
      | timestamp   | yesterday 23:30 |
      | cid_id      | 999993          |
      | person_id   | 12              |
      | gender      | m               |
      | nationality | abc             |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999994      |
      | person_id   | 12          |
      | gender      | m           |
      | nationality | abc         |
    Then the Centre "one" should show "3" Unexpected "Male" Check-ins