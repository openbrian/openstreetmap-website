Feature: Interact with the Microcosm
  In order to interact with a microcosm
  as a member
  I want to perform member actions

  Background:
    Given there is a microcosm "MappingDC", "Washington, DC, USA", "38.9", "-77.03", "38.516 * 10**7", "39.472 * 10**7", "-77.671 * 10**7", "-76.349 * 10**7"
    And the microcosm has description "MappingDC strives to improve OSM in the DC area"
    And the microcosm has the "Facebook" page "https://facebook.com/groups/mappingdc"
    And the microcosm has the "Twitter" page "https://twitter.com/mappingdc"
    And the microcosm has the "Website" page "https://mappingdc.org"
    And I am on the microcosm "MappingDC" page

    Scenario: RSVP for an event
      Given there is an event for this microcosm
      And there is a user "will_attend@example.com" with name "Will"
      And this user is an organizer of this microcosm
      And user "will_attend@example.com" logs in
      And I am on this event page
      Then I should see "0 people are going."
      Then I should see "Are you going?"
      And I press "Yes"
      And I am on this event page
      Then I should see "1 people are going."
