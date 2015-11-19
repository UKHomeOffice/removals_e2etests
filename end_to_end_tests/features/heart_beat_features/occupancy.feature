Feature: Occupancy details are displayed

  Scenario Outline: Occupied beds and utilisation is displayed correctly

    Given a heart beat is generated with the following information <centre_name>,<male>,<female>,<ooc_male>,<ooc_female>
    When I navigate to the bed management dashboard as a user
    And I click the stats link
    And occupancy has been reset to default
    And number centre name is displayed correctly on the stats page
    And the information is successfully uploaded to the heart beat api
    And the displayed number of male occupied beds is correct
    And the displayed number of female occupied beds is correct
    And the displayed number of male out of commission beds is correct
    And the displayed number of female out of commission beds is correct
    And the displayed number of male available beds is correct
    And the displayed number of female available beds is correct

    Examples:
      | centre_name | male | female | ooc_male | ooc_female |
      | one         | 10   | 0      | 2        | 0          |
      | two         | 80   | 90     | 20       | 10         |
      | three       | 45   | 25     | 10       | 35         |


