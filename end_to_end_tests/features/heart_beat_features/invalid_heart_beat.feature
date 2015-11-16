Feature: Invalid heart beat

  Scenario: A heart beat submitted with an uppercase centre name is rejected

    Given a heart beat is generated with the following information ONE,1,5,6,7
    And the information is uploaded to the heart beat api
    Then I should receive a 400 error
    And I should receive errors regarding the failed submission