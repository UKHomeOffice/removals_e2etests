Feature: Invalid event

  Scenario: A check in submitted with an uppercase centre name is rejected

    Given a check in has been generated for centre ONE
    And the information is uploaded to the events api
    Then I should receive a 400 error
    And I should receive errors regarding the failed submission