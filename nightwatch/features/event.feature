@wip
Feature: Event

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
      | two  | 2000          | 20000           | twoman,twobman | twowoman        |
    Given I am on the wallboard

  Scenario: Check in
    When I submit the following "check in" event:
      | centre      | one |
      | cid_id      | 123 |
      | person_id   | 12  |
      | gender      | m   |
      | nationality | abc |

  Scenario: Update individual
    When I submit the following "update individual" event:
      | centre      | one |
      | cid_id      | 123 |
      | person_id   | 12  |
      | gender      | m   |
      | nationality | abc |

  Scenario: Check out
    When I submit the following "check out" event:
      | centre    | one |
      | person_id | 12  |

  Scenario: Reinstatement
    When I submit the following "reinstatement" event:
      | centre    | one |
      | person_id | 12  |

  Scenario: Inter site transfer
    When I submit the following "inter site transfer" event:
      | centre    | one            |
      | centre_to | two            |
      | person_id | 12             |
      | reason    | Safety concern |

