@focus
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
#    And I submit the following "out commission" event:
#      | centre  | one                                       |
#      | bed_ref | abc1                                      |
#      | gender  | m                                         |
#      | reason  | Maintenance - Malicious/Accidental Damage |
#    And I submit the following "out commission" event:
#      | centre  | one                                     |
#      | bed_ref | abc2                                    |
#      | gender  | f                                       |
#      | reason  | Maintenance - Health and Safety Concern |
#    And I submit the following "out commission" event:
#      | centre  | one                         |
#      | bed_ref | abc3                        |
#      | gender  | m                           |
#      | reason  | Maintenance - Planned works |
#    And I submit the following "out commission" event:
#      | centre  | one         |
#      | bed_ref | abc4        |
#      | gender  | m           |
#      | reason  | Crime Scene |
#    And I submit the following "out commission" event:
#      | centre    | one         |
#      | bed_ref   | abc5        |
#      | timestamp | yesterday   |
#      | gender    | m           |
#      | reason    | Crime Scene |
#    And I submit the following "out commission" event:
#      | centre  | two               |
#      | bed_ref | xyz1              |
#      | gender  | f                 |
#      | reason  | Medical Isolation |
#    And I submit the following "out commission" event:
#      | centre  | two   |
#      | bed_ref | xyz2  |
#      | gender  | f     |
#      | reason  | Other |
#    And I submit the following "out commission" event:
#      | centre                     | two              |
#      | bed_ref                    | xyz3             |
#      | gender                     | m                |
#      | single_occupancy_person_id | 12               |
#      | reason                     | Single Occupancy |
#    And I submit the following "in commission" event:
#      | centre    | one  |
#      | timestamp | now  |
#      | bed_ref   | abc5 |
#    And I submit the following "out commission" event:
#      | centre    | two         |
#      | timestamp | 2 weeks ago |
#      | bed_ref   | xyz99       |
#      | gender    | f           |
#      | reason    | Other       |
#    And I submit the following "in commission" event:
#      | centre    | one       |
#      | timestamp | yesterday |
#      | bed_ref   | xyz99     |
    Then The "Summary" Occupancy Report for "today" should return:
      | centre | maleInUseMean | femaleInUseMean | maleOutOfCommissionMean | femaleOutOfCommissionMean |
      | one    | 5.5           | 11              | 16.5                    | 22                        |
      | two    | 27.5          | 33              | 38.5                    | 44                        |
    Then The "Raw" Occupancy Report for "today" should return:
      | centre | maleInUse | femaleInUse | maleOutOfCommission | femaleOutOfCommission |
      | one    | 10        | 2           | 3                   | 40                    |
      | one    | 1         | 20          | 30                  | 4                     |
      | two    | 5         | 60          | 70                  | 8                     |
      | two    | 50        | 6           | 7                   | 80                    |
#      | centre | gender | capacity | total beds available | unavailable beds | occupied beds | reasons for not meeting full occupancy                                                          |
#      | one    | male   | 100      | 70                   | 30               | 10            | Maintenance - Malicious/Accidental Damage x 1, Maintenance - Planned works x 1, Crime Scene x 2 |
#      | one    | female | 300      | 260                  | 40               | 20            | Maintenance - Health and Safety Concern x 1,                                                    |
#      | two    | male   | 200      | 130                  | 70               | 50            | Single Occupancy x 1                                                                            |
#      | two    | female | 400      | 320                  | 80               | 60            | Medical Isolation x 1, Other x 1                                                                |
#    And The Daily Occupancy Report for "yesterday" should return:
#      | centre | gender | capacity | total beds available | unavailable beds | occupied beds | reasons for not meeting full occupancy |
#      | one    | male   | 100      | 65                   | 35               | 15            | Crime Scene x 1                        |
#      | one    | female | 300      | 255                  | 45               | 25            |                                        |
#      | two    | male   | 200      | 150                  | 50               | 40            |                                        |
#      | two    | female | 400      | 345                  | 55               | 45            | Other x 1                              |
