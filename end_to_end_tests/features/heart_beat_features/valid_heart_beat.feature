Feature: Valid heart beat

  Scenario Outline: Submission of valid heart beats via the web service

    Given a heart beat is generated with the following information <centre_name>,<male>,<female>,<ooc_male>,<ooc_female>
    When I navigate to the bed management dashboard as a user
    And number centre name is displayed correctly
    And number available beds have been reset to default
    And the information is successfully uploaded to the heart beat api
    When the number available beds are calculated
    Then the number of available beds displayed is correct

    Examples:
      | centre_name | male | female | ooc_male | ooc_female |
      | one         | 10   | 0      | 2        | 0          |
      | two         | 80   | 90     | 20       | 10         |
      | three       | 45   | 25     | 10       | 35         |