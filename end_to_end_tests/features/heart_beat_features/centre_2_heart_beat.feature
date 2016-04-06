@heart_beat
Feature: Centre 2 heart beat

  Background:
    Given I attempt to log into the Bed Dashboard
    When my authentication is successful

  Scenario: A heart beat sent to centre 2 taking the availability to full
    Given a heart beat is generated with the following information centre name two,80,90,20,10 taking availability to full
    When I navigate to the bed management dashboard
    Then the centre name is displayed correctly on the dashboard page
    And number available beds have been reset to default
    And I expand to see further data
    And occupancy details have been reset to default
    When the information is successfully uploaded to the heart beat api
    Then the number of available beds displayed states FULL
    And the displayed number of male occupied beds is correct
    And the displayed number of female occupied beds is correct
    And the displayed number of male out of commission beds is correct
    And the displayed number of female out of commission beds is correct
    And the displayed number of male available beds within the breakdown states FULL
    And the displayed number of female available beds within the breakdown states FULL
    And I can see the data was last updated 30 seconds ago
    And I condense to see only the available beds