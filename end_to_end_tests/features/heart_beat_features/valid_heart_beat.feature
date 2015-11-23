Feature: Valid heart beat

  Scenario: Submission of valid heart beats via the web service


    Given a heart beat is generated with the following information one,10,0,2,0
    And a heart beat is generated with the following information two,80,90,20,10
    And a heart beat is generated with the following information three,45,25,10,35
    When I navigate to the bed management dashboard as a user
    And number centre name is displayed correctly on the dashboard page
    And number available beds have been reset to default
    And the information is successfully uploaded to the heart beat api
    Then the number of available beds displayed is correct
