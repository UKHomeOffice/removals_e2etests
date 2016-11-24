Feature: dailyOccupancyReport

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity |
      | one  | 100           | 300             |
      | two  | 200           | 400             |
    And I am on the wallboard

  Scenario: Bed Reports
    And I submit a heartbeat with:
      | centre                 | one |
      | male_occupied          | 10  |
      | female_occupied        | 2   |
      | male_outofcommission   | 3   |
      | female_outofcommission | 40  |
    And I submit a heartbeat with:
      | centre                 | one |
      | male_occupied          | 1   |
      | female_occupied        | 20  |
      | male_outofcommission   | 30  |
      | female_outofcommission | 4   |
    And I submit a heartbeat with:
      | centre                 | two |
      | male_occupied          | 5   |
      | female_occupied        | 60  |
      | male_outofcommission   | 70  |
      | female_outofcommission | 8   |
    And I submit a heartbeat with:
      | centre                 | two |
      | male_occupied          | 50  |
      | female_occupied        | 6   |
      | male_outofcommission   | 7   |
      | female_outofcommission | 80  |
    And I submit the following "out commission" event:
      | centre  | one                                       |
      | bed_ref | abc1                                      |
      | gender  | m                                         |
      | reason  | Maintenance - Malicious/Accidental Damage |
    And I submit the following "out commission" event:
      | centre  | one                                     |
      | bed_ref | abc2                                    |
      | gender  | f                                       |
      | reason  | Maintenance - Health and Safety Concern |
    And I submit the following "out commission" event:
      | centre  | one                         |
      | bed_ref | abc3                        |
      | gender  | m                           |
      | reason  | Maintenance - Planned works |
    And I submit the following "out commission" event:
      | centre  | one         |
      | bed_ref | abc4        |
      | gender  | m           |
      | reason  | Crime Scene |
    And I submit the following "out commission" event:
      | centre    | one           |
      | bed_ref   | abc5          |
      | timestamp | yesterday 6pm |
      | gender    | m             |
      | reason    | Crime Scene   |
    And I submit the following "out commission" event:
      | centre  | two               |
      | bed_ref | xyz1              |
      | gender  | f                 |
      | reason  | Medical Isolation |
    And I submit the following "out commission" event:
      | centre  | two   |
      | bed_ref | xyz2  |
      | gender  | f     |
      | reason  | Other |
    And I submit the following "out commission" event:
      | centre                     | two              |
      | bed_ref                    | xyz3             |
      | gender                     | m                |
      | single_occupancy_person_id | 12               |
      | reason                     | Single Occupancy |
    And I submit the following "in commission" event:
      | centre    | one  |
      | timestamp | now  |
      | bed_ref   | abc5 |
    And I submit the following "out commission" event:
      | centre    | two         |
      | timestamp | 2 weeks ago |
      | bed_ref   | xyz99       |
      | gender    | f           |
      | reason    | Other       |
    And I submit the following "in commission" event:
      | centre    | one       |
      | timestamp | yesterday |
      | bed_ref   | xyz99     |
    Then the Centre "one" should show the following Reasons under "Male" "Out of commission":
      | Crime Scene                               | 1 |
      | Maintenance - Malicious/Accidental Damage | 1 |
      | Maintenance - Planned works               | 1 |
    Then the Centre "one" should show the following Reasons under "Female" "Out of commission":
      | Maintenance - Health and Safety Concern | 1 |
    Then the Centre "two" should show the following Reasons under "Female" "Out of commission":
      | Other             | 2 |
      | Medical Isolation | 1 |
    Then The "Summary" Report for "today" should return:
      | centre | maleInUseMean | femaleInUseMean | maleOutOfCommissionMean | femaleOutOfCommissionMean | maleBedReasons                                                                               | femaleBedReasons                           |
      | one    | 5.5           | 11              | 16.5                    | 22                        | Crime Scene: 2, Maintenance - Malicious/Accidental Damage: 1, Maintenance - Planned works: 1 | Maintenance - Health and Safety Concern: 1 |
      | two    | 27.5          | 33              | 38.5                    | 44                        | Single Occupancy: 1                                                                          | Medical Isolation: 1, Other: 2             |
    Then The "Heartbeats" Report for "today" should return:
      | centre | maleInUse | femaleInUse | maleOutOfCommission | femaleOutOfCommission |
      | one    | 10        | 2           | 3                   | 40                    |
      | one    | 1         | 20          | 30                  | 4                     |
      | two    | 5         | 60          | 70                  | 8                     |
      | two    | 50        | 6           | 7                   | 80                    |
    Then The "Summary" Report for "yesterday" should return:
      | centre | maleBedReasons | femaleBedReasons |
      | one    | Crime Scene: 1 |                  |
      | two    |                | Other: 1         |


  Scenario: Detainee report
    Given I submit the following "check in" event:
      | centre      | one                  |
      | timestamp   | three days ago 23:30 |
      | cid_id      | 999991               |
      | person_id   | 12                   |
      | gender      | m                    |
      | nationality | abc                  |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999994      |
      | person_id   | 13          |
      | gender      | m           |
      | nationality | abc         |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999995      |
      | person_id   | 14          |
      | gender      | m           |
      | nationality | abc         |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999996      |
      | person_id   | 15          |
      | gender      | m           |
      | nationality | abc         |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999997      |
      | person_id   | 16          |
      | gender      | m           |
      | nationality | abc         |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999998      |
      | person_id   | 17          |
      | gender      | f           |
      | nationality | abc         |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999999      |
      | person_id   | 18          |
      | gender      | m           |
      | nationality | abc         |
    Given I submit the following "check in" event:
      | centre      | two         |
      | timestamp   | today 23:30 |
      | cid_id      | 999933      |
      | person_id   | 19          |
      | gender      | m           |
      | nationality | abc         |
    And I submit the following "check out" event:
      | centre    | two         |
      | timestamp | today 23:35 |
      | person_id | 19          |
    And I submit the following "check out" event:
      | centre    | two         |
      | timestamp | today 23:35 |
      | person_id | 25          |
    Then the Centre "one" should show "5" Unexpected "Male" Check-ins
    Then the Centre "two" should show "1" Unexpected "Male" Check-ins
    Then the Centre "one" should show "1" Unexpected "Female" Check-ins
    Then The "DetaineeEvents" Report for "today" should return:
      | centre | operation | cid_id | gender | nationality | centre_person_id |
      | one    | check in  | 999994 | male   | abc         | 13               |
      | one    | check in  | 999995 | male   | abc         | 14               |
      | one    | check in  | 999996 | male   | abc         | 15               |
      | one    | check in  | 999997 | male   | abc         | 16               |
      | one    | check in  | 999998 | female | abc         | 17               |
      | one    | check in  | 999999 | male   | abc         | 18               |
      | two    | check in  | 999933 | male   | abc         | 19               |
      | two    | check out | 999933 | male   | abc         | 19               |
      | two    | check out |        |        |             | 25               |
