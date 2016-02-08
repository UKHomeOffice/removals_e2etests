Feature: Centre 3 heart beat

  Scenario: A heart beat sent to centre 3 introducing a negative availability


    Given a heart beat is generated with the following information centre name three,45,25,10,35 introducing a negative availability
    When I navigate to the bed management dashboard
    Then the centre name is displayed correctly on the dashboard page
    And number available beds have been reset to default
    And I expand to see further data
    And occupancy details have been reset to default
    When the information is successfully uploaded to the heart beat api
    Then the number of available beds displayed is a negative value
    And the displayed number of male occupied beds is correct
    And the displayed number of female occupied beds is correct
    And the displayed number of male out of commission beds is correct
    And the displayed number of female out of commission beds is correct
    And the displayed number of male available beds within the breakdown is a negative value
    And the displayed number of female available beds within the breakdown is a negative value
    And I can see the data was last updated 30 seconds ago