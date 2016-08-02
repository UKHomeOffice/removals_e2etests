Feature: dailyOccupancyReport

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity |
      | one  | 100           | 300             |
      | two  | 200           | 400             |
    And I am on the wallboard

  Scenario: Heartbeat updates the wallboard
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
      | centre    | one         |
      | bed_ref   | abc5        |
      | timestamp | yesterday   |
      | gender    | m           |
      | reason    | Crime Scene |
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
    Then The "Summary" Occupancy Report for "today" should return:
      | centre | maleInUseMean | femaleInUseMean | maleOutOfCommissionMean | femaleOutOfCommissionMean | maleBedReasons                                                                               | femaleBedReasons                           |
      | one    | 5.5           | 11              | 16.5                    | 22                        | Crime Scene: 2, Maintenance - Malicious/Accidental Damage: 1, Maintenance - Planned works: 1 | Maintenance - Health and Safety Concern: 1 |
      | two    | 27.5          | 33              | 38.5                    | 44                        |                                                                                              | Other: 2, Medical Isolation: 1             |
    Then The "Raw" Occupancy Report for "today" should return:
      | centre | maleInUse | femaleInUse | maleOutOfCommission | femaleOutOfCommission |
      | one    | 10        | 2           | 3                   | 40                    |
      | one    | 1         | 20          | 30                  | 4                     |
      | two    | 5         | 60          | 70                  | 8                     |
      | two    | 50        | 6           | 7                   | 80                    |
    Then The "Summary" Occupancy Report for "yesterday" should return:
      | centre | maleBedReasons | femaleBedReasons |
      | one    | Crime Scene: 1 |                  |
      | two    |                | Other: 1         |

