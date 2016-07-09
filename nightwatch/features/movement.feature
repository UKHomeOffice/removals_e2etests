Feature: Movements

  Background:
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name | male_capacity | female_capacity | male_cid_name  | female_cid_name |
      | one  | 1000          | 10000           | oneman,onebman | onewoman        |
    And There are no existing ports
    And The following ports exist:
      | name     |
      | Big Port |
    And I am on the wallboard
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Expected incoming      | 0    |
      | Expected outgoing      | 0    |
      | Unexpected incoming    | 0    |

  Scenario: Unreconciled Out Movement shows as Expected Outgoing and does not affect Availability
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | Out          | oneman   | 111     | now     | Removal | 1433          |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 1000 |
      | Expected incoming      | 0    |
      | Expected outgoing      | 1    |
      | Unexpected incoming    | 0    |
    And the Centre "one" should show the following Reasons under "Male" "Expected outgoing":
      | 1433 | 1 |

  Scenario: Unreconciled In Movement shows as Expected incoming and reduces availability
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type | CID Person ID |
      | In           | oneman   | 111     | now     | Removal | 12345555      |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity   | 1000 |
      | Occupied               | 0    |
      | Beds out of commission | 0    |
      | Contingency            | 0    |
      | Prebookings            | 0    |
      | Availability           | 999  |
      | Expected incoming      | 1    |
      | Expected outgoing      | 0    |
      | Unexpected incoming    | 0    |
    And the Centre "one" should show the following Reasons under "Male" "Expected incoming":
      | 12345555 | 1 |

  Scenario: Non-occupancy Movements that relate to a port should be considered like any other
    When I submit the following movements:
      | MO In/MO Out | Location | MO Ref. | MO Date | MO Type       | CID Person ID |
      | Out          | Big Port | 110     | now     | Non-Occupancy | 12345555      |
      | In           | oneman   | 111     | now     | Non-Occupancy | 12345555      |
      | Out          | oneman   | 112     | now     | Non-Occupancy | 12345555      |
      | In           | Big Port | 113     | now     | Non-Occupancy | 12345555      |
    Then The Centre "one" should show the following under "Male":
      | Contractual Capacity | 1000 |
      | Availability         | 999  |
      | Expected incoming    | 1    |
      | Expected outgoing    | 1    |