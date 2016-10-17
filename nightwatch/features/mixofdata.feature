@mixup
Feature: Mixup

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name  | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one   | 1000          | 1000            | Oneman,onebman | Female One      |
      | two   | 200           | 500             | twoman,twobman | twowoman        |
      | three | 0             | 500             |                |                 |
      | four  | 100           | 0               |                |                 |
    And I am on the wallboard

  Scenario: Mix of data used for FE dev
    When I submit the following movements:
      | MO In/MO Out | Location   | MO Ref | MO Date | MO Type   | CID Person ID |
      | In           | twoman     | 991    | now     | Occupancy | 1000          |
      | In           | oneman     | 992    | now     | Occupancy | 2000          |
      | Out          | oneman     | 993    | now     | Occupancy | 6000          |
      | Out          | Female One | 995    | now     | Occupancy | 5000          |
      | Out          | Female One | 996    | now     | Occupancy | 3000          |
      | Out          | twowoman   | 997    | now     | Occupancy | 4000          |
    Given I submit the following prebookings:
      | task_force | location   | cid_id | timestamp |
      | htu        | oneman     |        | today 9am |
      | ops1       | oneman     |        | today 9am |
      | ops2       | Female One |        | today 9am |
      | depmu      | oneman     |        | today 9am |
      | depmu ops1 | oneman     |        | today 9am |
      | htu        | oneman     | 1000   | today 9am |
      | htu ops1   | oneman     | 2000   | today 9am |
      | depmu      | oneman     | 3000   | today 9am |
      | depmu ops1 | oneman     | 4000   | today 9am |
    When I submit a heartbeat with:
      | centre                 | one |
      | male_occupied          | 100 |
      | female_occupied        | 200 |
      | male_outofcommission   | 200 |
      | female_outofcommission | 300 |
    When I submit a heartbeat with:
      | centre                 | two |
      | male_occupied          | 100 |
      | female_occupied        | 200 |
      | male_outofcommission   | 200 |
      | female_outofcommission | 300 |
    Given I submit the following "check in" event:
      | centre      | two    |
      | timestamp   | now    |
      | cid_id      | 999909 |
      | person_id   | 13     |
      | gender      | f      |
      | nationality | abc    |
    Given I submit the following "check in" event:
      | centre      | one    |
      | timestamp   | now    |
      | cid_id      | 999999 |
      | person_id   | 12     |
      | gender      | m      |
      | nationality | abc    |
    Given I submit the following "check in" event:
      | centre      | one                  |
      | timestamp   | three days ago 23:30 |
      | cid_id      | 999991               |
      | person_id   | 12                   |
      | gender      | m                    |
      | nationality | abc                  |
    Given I submit the following "check in" event:
      | centre      | one                |
      | timestamp   | two days ago 23:30 |
      | cid_id      | 999992             |
      | person_id   | 12                 |
      | gender      | m                  |
      | nationality | abc                |
    Given I submit the following "check in" event:
      | centre      | one             |
      | timestamp   | yesterday 23:30 |
      | cid_id      | 999993          |
      | person_id   | 12              |
      | gender      | m               |
      | nationality | abc             |
    Given I submit the following "check in" event:
      | centre      | one         |
      | timestamp   | today 23:30 |
      | cid_id      | 999994      |
      | person_id   | 12          |
      | gender      | m           |
      | nationality | abc         |
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
      | centre    | one   |
      | timestamp | now   |
      | bed_ref   | abc7  |
      | gender    | f     |
      | reason    | Other |
