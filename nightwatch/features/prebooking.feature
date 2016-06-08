Feature: Prebooking & Contingency

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 1000            | oneman,onebman | onewoman        |
      | two  | 2000          | 2000            | twoman,twobman | twowoman        |
    And I am on the wallboard

  Scenario: New valid Pre-bookings replace existing bookings
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops2       | oneman   |        | today 9am |
      | depmu      | oneman   |        | today 9am |
    When I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops1       | oneman   |        | today 9am |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Contingency          | 0    |
      | Prebookings          | 1    |
      | Availability         | 999  |

  Scenario: New valid Contingency bookings replace existing bookings
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops2       | oneman   |        | today 9am |
      | depmu      | oneman   |        | today 9am |
    When I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | depmu      | oneman   |        | today 9am |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Contingency          | 1    |
      | Prebookings          | 0    |
      | Availability         | 999  |

  Scenario: New valid Movement In Orders replace related pre-bookings
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops1       | oneman   |        | today 9am |
      | ops1       | oneman   | 1000   | today 9am |
      | ops1       | oneman   | 2000   | today 9am |
      | ops1       | oneman   | 3000   | today 9am |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type   | CID Person ID |
      | In           | twoman   | 991     | now     | Occupancy | 1000          |
      | In           | oneman   | 992     | now     | Occupancy | 2000          |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Prebookings          | 2    |
      | Expected incoming    | 1    |
      | Availability         | 997  |
    Then The Centre "two" should show the following under "Male":
      | Contractual Capacity | 2000 |
      | Prebookings          | 0    |
      | Expected incoming    | 1    |
      | Availability         | 1999 |

  Scenario: New valid Movement In Orders replace related Contingency bookings
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | htu        | oneman   |        | today 9am |
      | htu ops1   | oneman   | 1000   | today 9am |
      | depmu      | oneman   | 2000   | today 9am |
      | depmu ops1 | oneman   | 3000   | today 9am |
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type   | CID Person ID |
      | In           | twoman   | 991     | now     | Occupancy | 1000          |
      | In           | oneman   | 992     | now     | Occupancy | 2000          |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Contingency          | 2    |
      | Expected incoming    | 1    |
      | Availability         | 997  |
    Then The Centre "two" should show the following under "Male":
      | Contractual Capacity | 2000 |
      | Contingency          | 0    |
      | Expected incoming    | 1    |
      | Availability         | 1999 |
    And the Centre "one" should show the following CIDS under "Male" "Expected incoming":
      | CID Person ID |
      | 2000          |
    And the Centre "two" should show the following CIDS under "Male" "Expected incoming":
      | CID Person ID |
      | 1000          |

  Scenario: New valid pre-bookings are ignored if related Movement In Order exists
    Given I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type   | CID Person ID |
      | In           | twoman   | 991     | now     | Occupancy | 1000          |
      | In           | oneman   | 992     | now     | Occupancy | 2000          |
    When I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | ops1       | oneman   |        | today 9am |
      | ops1       | oneman   | 1000   | today 9am |
      | ops1       | oneman   | 2000   | today 9am |
      | ops1       | oneman   | 3000   | today 9am |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Prebookings          | 2    |
      | Expected incoming    | 1    |
      | Availability         | 997  |
    Then The Centre "two" should show the following under "Male":
      | Contractual Capacity | 2000 |
      | Prebookings          | 0    |
      | Expected incoming    | 1    |
      | Availability         | 1999 |

  Scenario: New valid Contingency bookings are ignored if related Movement In Order exists
    Given I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type   | CID Person ID |
      | In           | twoman   | 991     | now     | Occupancy | 1000          |
      | In           | oneman   | 992     | now     | Occupancy | 2000          |
    When I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | htu        | oneman   |        | today 9am |
      | htu ops1   | oneman   | 1000   | today 9am |
      | depmu      | oneman   | 2000   | today 9am |
      | depmu ops1 | oneman   | 3000   | today 9am |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Contingency          | 2    |
      | Expected incoming    | 1    |
      | Availability         | 997  |
    Then The Centre "two" should show the following under "Male":
      | Contractual Capacity | 2000 |
      | Contingency          | 0    |
      | Expected incoming    | 1    |
      | Availability         | 1999 |

  Scenario: New valid Pre-bookings are ignored
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
      | Contractual Capacity | 1000 |
      | Prebookings          | 1    |
      | Availability         | 999  |

  Scenario: New valid Contingency bookings are ignored
    Given I submit the following prebookings:
      | task_force | location | cid_id | timestamp |
      | depmu      | oneman   |        | today 9am |
    When I submit the following prebookings:
      | task_force  | location | cid_id | timestamp    |
      | htu         |          |        | today 9am    |
      | htu ops 1   | oneman   |        | today 6am    |
      | depmu ops 1 | oneman   |        | tomorrow 8am |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Contingency          | 1    |
      | Availability         | 999  |
