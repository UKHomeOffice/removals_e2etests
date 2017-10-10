Feature: Prebooking & Contingency

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 1000            | Oneman,onebman | Female One      |
      | two  | 2000          | 2000            | twoman,twobman | twowoman        |
    And I am on the wallboard

  Scenario: New valid Pre-bookings replace existing bookings
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops2       | oneman   |        | today 9am |
      | depmu      | oneman   |        | today 9am |
    When I submit the following prebookings:
      | task_force | location   | cid_id | timestamp |
      | ops1       | oneman     |        | today 9am |
      | ops1       | Female One |        | today 9am |
      | depmu      | oneman     |        | today 9am |
      | depmu      | oneman     |        | today 9am |
    Then the Centre "one" should show the following Reasons under "Male" "Prebooked":
      | OPS1 | 1 |
    Then the Centre "one" should show the following Reasons under "Female" "Prebooked":
      | OPS1 | 1 |
    Then The Centre "one" should show the following under "Male":
      | Contingency         | 2   |
      | Prebooked           | 1   |
      | Estimated available | 997 |
    Then The Centre "one" should show the following under "Female":
      | Contingency         | 0   |
      | Prebooked           | 1   |
      | Estimated available | 999 |

  Scenario: New valid Movement In Orders replace related pre-bookings
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops1       | oneman   |        | today 9am |
      | ops1       | oneman   | 1000   | today 9am |
      | ops1       | oneman   | 2000   | today 9am |
      | ops1       | oneman   | 3000   | today 9am |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type   | CID Person ID |
      | In           | twoman   | 991    | now     | Occupancy | 1000          |
      | In           | oneman   | 992    | now     | Occupancy | 2000          |
    Then The Centre "one" should show the following under "Male":
      | Prebooked           | 2   |
      | Incoming            | 1   |
      | Estimated available | 997 |
    And the Centre "one" should show the following Reasons under "Male" "Prebooked":
      | OPS1 | 1 |
      | 3000 | 1 |
    And The Centre "two" should show the following under "Male":
      | Prebooked           | 0    |
      | Incoming            | 1    |
      | Estimated available | 1999 |

  Scenario: New valid pre-bookings are ignored if related Movement In Order exists
    Given I submit the following movements:
      | MO In/MO Out | Location | MO Ref | MO Date | MO Type   | CID Person ID |
      | In           | twoman   | 991    | now     | Occupancy | 1000          |
      | In           | oneman   | 992    | now     | Occupancy | 2000          |
    Then The Centre "one" should show the following under "Male":
      | Incoming | 1 |
    When I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops1       | oneman   |        | today 9am |
      | ops1       | oneman   | 1000   | today 9am |
      | ops1       | oneman   | 2000   | today 9am |
      | ops1       | oneman   | 3000   | today 9am |
    Then The Centre "one" should show the following under "Male":
      | Prebooked           | 2   |
      | Incoming            | 1   |
      | Estimated available | 997 |
    And the Centre "one" should show the following Reasons under "Male" "Prebooked":
      | OPS1 | 1 |
      | 3000 | 1 |
    Then The Centre "two" should show the following under "Male":
      | Prebooked           | 0    |
      | Incoming            | 1    |
      | Estimated available | 1999 |

  Scenario: New valid Contingency bookings are ignored if they have a cid
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | htu        | oneman   |        | today 9am |
      | htu ops1   | oneman   |        | today 9am |
      | depmu      | oneman   |        | today 9am |
      | depmu ops1 | oneman   |        | today 9am |
      | htu        | oneman   | 1000   | today 9am |
      | htu ops1   | oneman   | 2000   | today 9am |
      | depmu      | oneman   | 3000   | today 9am |
      | depmu ops1 | oneman   | 4000   | today 9am |
    Then The Centre "one" should show the following under "Male":
      | Contingency         | 4   |
      | Estimated available | 996 |
    And the Centre "one" should show the following Reasons under "Male" "Contingency":
      | HTU        | 1 |
      | HTU OPS1   | 1 |
      | DEPMU      | 1 |
      | DEPMU OPS1 | 1 |

  Scenario: New invalid Pre-bookings are ignored
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops1       | oneman   |        | today 9am |
    When I submit the following prebookings:
      | task_force | location | cid_id | timestamp    |
      |            | oneman   |        | today 9am    |
      | ops1       |          |        | today 9am    |
      | ops1       | oneman   |        | today 6am    |
      | ops1       | oneman   |        | tomorrow 8am |
    Then The Centre "one" should show the following under "Male":
      | Prebooked           | 1   |
      | Estimated available | 999 |
    And the Centre "one" should show the following Reasons under "Male" "Prebooked":
      | OPS1 | 1 |

  Scenario: New invalid Contingency bookings are ignored
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | depmu      | oneman   |        | today 9am |
    When I submit the following prebookings:
      | task_force  | location | cid_id | timestamp    |
      | htu         |          |        | today 9am    |
      | htu ops 1   | oneman   |        | today 5:59am |
      | depmu ops 1 | oneman   |        | tomorrow 8am |
    Then The Centre "one" should show the following under "Male":
      | Contingency         | 1   |
      | Estimated available | 999 |
    And the Centre "one" should show the following Reasons under "Male" "Contingency":
      | DEPMU | 1 |
