Feature: Valid heart beat

  Scenario: Submission of valid heart beats via the web service


    Given I navigate to the bed management dashboard
    And a heart beat is generated with the following information one,10,0,2,0
    And a heart beat is generated with the following information two,80,90,20,10
    And a heart beat is generated with the following information three,45,25,10,35
    And the centre name is displayed correctly on the dashboard page
    And number available beds have been reset to default
    When I click the stats link
    And occupancy details have been reset to default
    When the information is successfully uploaded to the heart beat api
    Then the number of available beds displayed is correct
    And the displayed number of female occupied beds is correct
    And the displayed number of male out of commission beds is correct
    And the displayed number of female out of commission beds is correct
    And the displayed number of male available beds is correct
    And the displayed number of female available beds is correct
