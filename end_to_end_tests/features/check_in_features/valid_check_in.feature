@events @wip
Feature: A valid check in

  Scenario: Submission of a valid check in via the web service

    Given a check in has been generated for centre two
    When I navigate to the bed management dashboard as a user
    And I navigate to the latest events tab
    And there are no events
    And the information is successfully uploaded to the events api
    Then partial check in information for the first event is displayed