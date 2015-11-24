Feature: Occupancy details are displayed

  Scenario: Occupied beds and utilisation is displayed correctly

    Given I navigate to the bed management dashboard as a user
    And a heart beat is generated with the following information one,10,0,2,0
    And a heart beat is generated with the following information two,80,90,20,10
    And a heart beat is generated with the following information three,45,25,10,35
    When I click the stats link
    And occupancy has been reset to default
    And number centre name is displayed correctly on the stats page
    And the information is successfully uploaded to the heart beat api
    Then the displayed number of male occupied beds is correct
    And the displayed number of female occupied beds is correct
    And the displayed number of male out of commission beds is correct
    And the displayed number of female out of commission beds is correct
    And the displayed number of male available beds is correct
    And the displayed number of female available beds is correct