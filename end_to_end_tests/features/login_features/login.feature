@env_only
Feature: Successful and unsuccessful login

  Scenario: Successful login

    Given I attempt to log into the Bed Dashboard
    When my authentication is successful
    Then I am directed to the Bed Dashboard web page

  Scenario: Unsuccessful login

    Given I attempt to log into the Bed Dashboard
    When my authentication is unsuccessful
    Then I am presented with a log in unsuccessful message