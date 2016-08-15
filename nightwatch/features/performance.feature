@performance
Feature: Performance

#  For performance testing we will test with 3 times normal load
#
#  Normal load is defined as:
#  1 event(s) per minute
#  11 heartbeats a minute
#  1 cid payload of 900 movements every 4 minutes
#  1 prebooking payload of 100 movements every 4 minutes
#  25 simultanious users

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name   | male_capacity | female_capacity | male_cid_name | female_cid_name |
      | one    | 1000          | 10000           | mone          | fone            |
      | two    | 2000          | 20000           | mtwo          | ftwo            |
      | three  | 3000          | 30000           | mthree        | fthree          |
      | four   | 4000          | 40000           | mfour         | ffour           |
      | five   | 5000          | 50000           | mfive         | ffive           |
      | six    | 6000          | 60000           | msix          | fsix            |
      | seven  | 7000          | 70000           | mseven        | fseven          |
      | eight  | 8000          | 80000           | meight        | feight          |
      | nine   | 9000          | 90000           | mnine         | fnine           |
      | ten    | 10000         | 100000          | mten          | ften            |
      | eleven | 11000         | 110000          | meleven       | feleven         |
    And I am on the wallboard
    And I spawn "75" socket clients to the backend
    And I capture the browser memory footprint

  @performance
  Feature: Performance

#  For performance testing we will test with 3 times normal load
#
#  Normal load is defined as:
#  1 event(s) per minute
#  11 heartbeats a minute
#  1 cid payload of 900 movements every 4 minutes
#  1 prebooking payload of 100 movements every 4 minutes
#  25 simultanious users

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name   | male_capacity | female_capacity | male_cid_name | female_cid_name |
      | one    | 1000          | 10000           | mone          | fone            |
      | two    | 2000          | 20000           | mtwo          | ftwo            |
      | three  | 3000          | 30000           | mthree        | fthree          |
      | four   | 4000          | 40000           | mfour         | ffour           |
      | five   | 5000          | 50000           | mfive         | ffive           |
      | six    | 6000          | 60000           | msix          | fsix            |
      | seven  | 7000          | 70000           | mseven        | fseven          |
      | eight  | 8000          | 80000           | meight        | feight          |
      | nine   | 9000          | 90000           | mnine         | fnine           |
      | ten    | 10000         | 100000          | mten          | ften            |
      | eleven | 11000         | 110000          | meleven       | feleven         |
    And I am on the wallboard
    And I spawn "75" socket clients to the backend
    And I capture the browser memory footprint

  Scenario: 3x normal load heartbeat
    When I submit "33" random "heartbeats" every "1" minute for "10" minutes all taking less than "5000" milliseconds each
    Then all the socket clients should have received "660" message each
    And I capture the browser memory footprint
    Then The browser memory should not have increased by more than 32mb

  Scenario: Events
    When I submit "3" random "events" every "1" minute for "10" minutes all taking less than "5000" milliseconds each
#    Then all the socket clients should have received "210" message each
    And I capture the browser memory footprint
    Then The browser memory should not have increased by more than 10mb

  Scenario: 3x normal load movements
    When I submit "2700" random "movements" every "2" minute for "10" minutes all taking less than "5000" milliseconds each
#    Then all the socket clients should have received "220" message each
    And I capture the browser memory footprint
    Then The browser memory should not have increased by more than 32mb

  Scenario: 3x normal load prebookings
    When I submit "300" random "prebookings" every "2" minute for "10" minutes all taking less than "5000" milliseconds each
#    Then all the socket clients should have received "210" message each
    And I capture the browser memory footprint
    Then The browser memory should not have increased by more than 32mb
