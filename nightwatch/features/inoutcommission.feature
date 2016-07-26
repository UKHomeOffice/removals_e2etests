Feature: Bed commission state changing events

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity |
      | one  | 1000          |
      | two  | 500           |
    Given I am on the wallboard

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
      | single_occupancy_person_id | 9999             |
      | reason                     | Single Occupancy |
    Then the Centre "one" should show the following Reasons under "Male" "Beds out of commission":
      | Maintenance - Malicious/Accidental Damage | 1 |
      | Maintenance - Health and Safety Concern   | 1 |
      | Maintenance - Planned works               | 1 |
      | Crime Scene                               | 1 |
      | Medical Isolation                         | 1 |
      | Other                                     | 1 |
      | Single Occupancy                          | 1 |
    Then the Centre "two" should not show the following Reasons under "Male" "Beds out of commission":
      | Maintenance - Malicious/Accidental Damage | 1 |
      | Maintenance - Health and Safety Concern   | 1 |
      | Maintenance - Planned works               | 1 |
      | Crime Scene                               | 1 |
      | Medical Isolation                         | 1 |
      | Other                                     | 1 |
      | Single Occupancy                          | 1 |

  Scenario: Bed going out and back in commission
    Given I submit the following "out commission" event:
      | centre    | one   |
      | timestamp | now   |
      | bed_ref   | abc6  |
      | gender    | m     |
      | reason    | Other |
    Then the Centre "one" should show the following Reasons under "Male" "Beds out of commission":
      | Other | 1 |
    When I submit the following "in commission" event:
      | centre    | one  |
      | timestamp | now  |
      | bed_ref   | abc6 |
    Then the Centre "one" should not show the following Reasons under "Male" "Beds out of commission":
      | Other | 1 |
