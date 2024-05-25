/*global showMap,formMapInit*/

$(document).ready(function () {
  if ($("#event_form").length) {
    formMapInit("event_form");
  } else if ($("#event_map").length) {
    showMap("event_map");
  }
});
