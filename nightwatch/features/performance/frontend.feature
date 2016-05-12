@frontend @focus
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
    And I spawn a single socket client to the backend
    And I capture the browser memory footprint

  Scenario: An average hour of stuff
    Given I submit "33" random "heartbeats"
    When I submit "11" random "heartbeats" every "single" minute for "60" minutes all taking less than "1000" milliseconds each
    And I submit "2" random "events" every "single" minute for "60" minutes all taking less than "500" milliseconds each
    And I submit "900" random "movements" every "4" minutes for "60" minutes all taking less than "5000" milliseconds each
    And I submit "100" random "prebookings" every "4" minute for "60" minutes all taking less than "1000" milliseconds each
    Then I capture the browser memory footprint
    And The browser memory should not have increased by more than 32mb
