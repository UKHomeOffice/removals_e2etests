Feature: Centre 1 heart beat

  Scenario: Submission of valid heart beat via the web service to centre 1


    Given a heart beat is generated with the following information centre name one,10,0,2,0
    When I navigate to the bed management dashboard
    Then the centre name is displayed correctly on the dashboard page
    And number available beds have been reset to default
    And I expand to see further data
    And occupancy details have been reset to default
    When the information is successfully uploaded to the heart beat api
    Then the number of available beds displayed is correct
    And the displayed number of male occupied beds is correct
    And the displayed number of male out of commission beds is correct
    And the displayed number of male available beds within the breakdown is correct
    And I can see the data was last updated 30 seconds ago


  Scenario: A bed placed out of commission and then recommissioned

    Given 3 bed have been put out of commission for centre one
    When the information is successfully uploaded to the heart beat api
    When I navigate to the bed management dashboard
    And I expand to see further data
    Then the dashboard should display the updated out of commission beds number on the dashboard
    Given 1 out of commission bed has been recommissioned for centre one
    When the information is successfully uploaded to the heart beat api
    Then the dashboard should display 2 out of commission beds number on the dashboard