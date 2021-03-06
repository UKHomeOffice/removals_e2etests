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
      | In use              | 0    |
      | Out of commission   | 0    |
      | Contingency         | 0    |
      | Prebooked           | 0    |
      | Estimated available | 1000 |
      | Incoming            | 0    |
      | Outgoing            | 0    |
    And the Centre "one" should show "0" Unexpected "Female" Check-ins
    And The Centre "one" should show the following under "Female":
      | In use              | 0     |
      | Out of commission   | 0     |
      | Contingency         | 0     |
      | Prebooked           | 0     |
      | Estimated available | 10000 |
      | Incoming            | 0     |
      | Outgoing            | 0     |
    And The Centre "two" should show the following under "Male":
      | In use              | 0    |
      | Out of commission   | 0    |
      | Contingency         | 0    |
      | Prebooked           | 0    |
      | Estimated available | 2000 |
      | Incoming            | 0    |
      | Outgoing            | 0    |
    And the Centre "two" should show "0" Unexpected "Male" Check-ins
    And The Centre "two" should show the following under "Female":
      | In use              | 0     |
      | Out of commission   | 0     |
      | Contingency         | 0     |
      | Prebooked           | 0     |
      | Estimated available | 20000 |
      | Incoming            | 0     |
      | Outgoing            | 0     |
    And the Centre "two" should show "0" Unexpected "Female" Check-ins


  Scenario: Centre one's events shouldn't affect Centre two, male shouldn't affect female
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111    | now     | Removal | 1234          |
      | In           | onewoman | 222    | now     | Removal | 4321          |
      | In           | onewoman | 333    | now     | Removal | 5432          |
    Then The Centre "one" should show the following under "Male":
      | Estimated available | 999 |
      | Incoming            | 1   |
    And The Centre "one" should show the following under "Female":
      | Estimated available | 9998 |
      | Incoming            | 2    |
    And The Centre "two" should show the following under "Male":
      | Estimated available | 2000 |
      | Incoming            | 0    |
    And The Centre "two" should show the following under "Female":
      | Estimated available | 20000 |
      | Incoming            | 0     |
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
      | Estimated available | 1000 |
      | Incoming            | 0    |
    And The Centre "one" should show the following under "Female":
      | Estimated available | 10000 |
      | Incoming            | 0     |
    And The Centre "two" should show the following under "Male":
      | Estimated available | 2000 |
      | Incoming            | 0    |
    And The Centre "two" should show the following under "Female":
      | Estimated available | 20000 |
      | Incoming            | 0     |

