Feature: Amendment of IRC-end problems

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | one            | one woman       |
    And I am on the wallboard

  Scenario: Mistyped CID ID from IRC will show as unexpected
    Given I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | In           | one      | 111    | now     | Removal | 999999        |
    When I submit the following "check in" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999998 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Then the Centre "one" should show "1" Unexpected "Male" Check-ins

  Scenario: Amending mistyped CID ID from IRC will remove the unexpected warning
    Given I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type | CID Person ID |
      | In           | one      | 111    | now     | Removal | 999999        |
    When I submit the following "check in" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999998 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    And I submit the following "update individual" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Then the Centre "one" should show "0" Unexpected "Male" Check-ins