Feature: Interact with the Microcosm
  In order to interact with a microcosm
  as a member
  I want to perform member actions

  Background:
    Given there is a microcosm "MappingDC", "Washington, DC, USA", "38.9", "-77.03", "38.516", "39.472", "-77.671", "-76.349"
    And the microcosm has description "MappingDC strives to improve OSM in the DC area"
    And the microcosm has the "Facebook" page "https://facebook.com/groups/mappingdc"
    And the microcosm has the "Twitter" page "https://twitter.com/mappingdc"
    And the microcosm has the "Website" page "https://mappingdc.org"
    And I am on the microcosm "MappingDC" page

  Scenario: A user may leave a microcosm
    Given there is a user "abe@example.com" with name "Abraham"
    And this user is an "member" of this microcosm
    When user "abe@example.com" logs in
    And I am on the microcosm "MappingDC" page
    And I should see a "Leave" button
    And I press "Leave"
    Then I should see a "Join" button

  Scenario: RSVP for an event
      Given there is an event for this microcosm
      And there is a user "will_attend@example.com" with name "Will"
      And this user is an "member" of this microcosm
      And user "will_attend@example.com" logs in
      And I am on this event page
      Then I should see "0 people are going."
      Then I should see "Are you going?"
      And I press "yes"
      And I am on this event page
      Then I should see "1 people are going."
      And I press "no"
      And I am on this event page
      Then I should see "0 people are going."

    Scenario: Members should not see join button
      Given there is a user "will_attend@example.com" with name "Will"
      And this user is an "member" of this microcosm
      And user "will_attend@example.com" logs in
      And I am on the microcosm "MappingDC" page
      Then I should not see a "Join" button

    Scenario: Step up
      Given there is a user "abe@example.com" with name "Abe"
      And this user is an "member" of this microcosm
      Given this microcosm has no organizers
      When user "abe@example.com" logs in
      And I am on the microcosm "MappingDC" page
      And I click "Step up"
      Then I should see "Organizers Abe"