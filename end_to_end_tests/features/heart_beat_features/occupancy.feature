#Feature: Occupancy details are displayed
#
#  Scenario: Occupied beds and utilisation is displayed correctly
#
#    Given a heart beat is generated with the following information two,30,10,1,2
#    When I navigate to the bed management dashboard as a user
#    And I click the stats link
#    And occupancy has been reset to default
#    And the information is successfully uploaded to the heart beat api
#    When the occupancy percentage is calculated
#    Then the displayed occupancy percentage is correct
#    And the displayed number of male occupied beds is correct
#    And the displayed number of female occupied beds is correct
#    And the displayed number of male out of commission beds is correct
#    And the displayed number of female out of commission beds is correct
#
#
