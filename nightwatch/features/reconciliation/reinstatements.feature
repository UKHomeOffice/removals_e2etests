Feature: Reinstatements

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | male_cid_name |
      | one  | 1000          | oneman        |
    And I am on the wallboard
    And The following detainee exists:
      | centre      | one  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    And I submit the following "check out" event:
      | centre    | one |
      | person_id | 12  |

  Scenario: Reconciled Reinstatement on expected movement
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111    | now     | Removal | 1234          |
    Then The Centre "one" should show the following under "Male":
      | Outgoing | 0 |
    And I submit the following "reinstatement" event:
      | centre    | one |
      | timestamp | now |
      | person_id | 12  |
    Then The Centre "one" should show the following under "Male":
      | Outgoing | 1 |