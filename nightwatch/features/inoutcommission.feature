@focus
Feature: Bed commission state changing events

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity |
      | one  | 1000          |
    Given I am on the wallboard
    And The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |

  Scenario: Out of commission collection of reasons
    Given I submit the following "out commission" event:
      | centre    | one                                       |
      | timestamp | now                                       |
      | bed_ref   | abc1                                      |
      | gender    | m                                         |
      | reason    | Maintenance - Malicious/Accidental Damage |
    And I submit the following "out commission" event:
      | centre    | one                                     |
      | timestamp | now                                     |
      | bed_ref   | abc2                                    |
      | gender    | m                                       |
      | reason    | Maintenance - Health and Safety Concern |
    And I submit the following "out commission" event:
      | centre    | one                         |
      | timestamp | now                         |
      | bed_ref   | abc3                        |
      | gender    | m                           |
      | reason    | Maintenance - Planned works |
    And I submit the following "out commission" event:
      | centre    | one         |
      | timestamp | now         |
      | bed_ref   | abc4        |
      | gender    | m           |
      | reason    | Crime Scene |
    And I submit the following "out commission" event:
      | centre    | one               |
      | timestamp | now               |
      | bed_ref   | abc5              |
      | gender    | m                 |
      | reason    | Medical Isolation |
    And I submit the following "out commission" event:
      | centre    | one   |
      | timestamp | now   |
      | bed_ref   | abc6  |
      | gender    | m     |
      | reason    | Other |
    And I submit the following "out commission" event:
      | centre                     | one              |
      | timestamp                  | now              |
      | bed_ref                    | abc7             |
      | gender                     | m                |
      | single_occupancy_person_id | 12               |
      | reason                     | Single Occupancy |
    Then The Centre "one" should show the following under "Male" "Out of commission":
      | Maintenance - Malicious/Accidental Damage | 1 |
      | Maintenance - Health and Safety Concern   | 1 |
      | Maintenance - Planned works               | 1 |
      | Crime Scene                               | 1 |
      | Medical Isolation                         | 1 |
      | Other                                     | 1 |
      | Single Occupancy                          | 1 |

  Scenario: Single occupancy detail
    Given The following detainee exists:
      | centre      | one  |
      | cid_id      | 1234 |
      | person_id   | 12   |
      | gender      | m    |
      | nationality | abc  |
    And I submit the following "out commission" event:
      | centre                     | one              |
      | timestamp                  | now              |
      | bed_ref                    | abc7             |
      | gender                     | m                |
      | single_occupancy_person_id | 12               |
      | reason                     | Single Occupancy |
    Then The Centre "one" should show the following under "Male" "Out of commission" "Single Occupancy":
      | CID Person ID |
      | 1234          |

  Scenario: Bed going out and back in commission
    Given I submit the following "out commission" event:
      | centre    | one   |
      | timestamp | now   |
      | bed_ref   | abc6  |
      | gender    | m     |
      | reason    | Other |
    Then The Centre "one" should show the following under "Male" "Out of commission":
      | Other | 1 |
    Then I submit the following "in commission" event:
      | centre    | one  |
      | timestamp | now  |
      | bed_ref   | abc6 |
    Then The Centre "one" should show the following under "Male" "Out of commission":
      | Other | 0 |

  Scenario: Bed going out and back in commission out of order
    Given I submit the following "in commission" event:
      | centre    | one  |
      | timestamp | now  |
      | bed_ref   | abc6 |
    And I submit the following "out commission" event:
      | centre    | one       |
      | timestamp | 1 day ago |
      | bed_ref   | abc6      |
      | gender    | m         |
      | reason    | Other     |
    Then The Centre "one" should show the following under "Male" "Out of commission":
      | Other | 0 |
