/*global showMap,formMapInput*/

$(document).ready(function () {
  function init_microcosm_form() {
    formMapInput("microcosm_map_form", "microcosm");
  }

  function init_microcosm_show() {
    showMap("microcosm_map");
  }

  if ($("#microcosm_map_form").length) {
    init_microcosm_form();
  } else if ($("#microcosm_map").length) {
    init_microcosm_show();
  }
});