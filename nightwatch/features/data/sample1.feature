@data @sample1
Feature: Data Sample 1

  Scenario: Loading Data Sample 1
    Given I am a logged in user
    And There are no existing centres
    And The following centres exist:
      | name          | male_capacity | female_capacity | male_cid_name     | female_cid_name     |
      | brookhouse    | 448           | 0               | brookhouse        |                     |
      | campsfield    | 282           | 0               | campsfieldmale    |                     |
      | colnbrook     | 369           | 27              | colnbrookmale     | colnbrookfemale     |
      | dungavel      | 235           | 14              | dungavelmale      | dungavelfemale      |
      | harmondsworth | 665           | 0               | harmondsworthmale | harmondsworthfemale |
      | larnehouse    | 19            | 0               | larnehousemixed   |                     |
      | mortonhall    | 392           | 0               | mortonhall        |                     |
      | peninehouse   | 32            | 0               | peninehousemixed  |                     |
      | tinsleyhouse  | 119           | 0               | tinsleyhouse      |                     |
      | theverne      | 580           | 0               | theverne          |                     |
      | yarlswood     | 304           | 38              | yarlswoodmale     | yarlswoodfemale     |
    Then I generate 100 unreconciled movements across the estate
    Then I generate 100 unreconciled events across the estate
    Then I generate 100 reconciliations across the estate
