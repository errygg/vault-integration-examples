$(document).ready(function() {


$('#restart').click(function(event) {
  // Stop the default action
  event.preventDefault();
  action = "POST";
  url = "/restart";

  $.ajax({
      type: action,
      url: url,
      dataType: "test",
      success: function(response, textStatus, jqXHR) {
          alert("restart happened!")
      },
      error: function(jqXHR, textStatus, errorThrown) {
          $('#username').html("New username and password has been generated! Please click <a href='/getdbcredentials'>here</a> to obtain new dynamic credentials")
      },
  });
}); // End of Ajax


}); // End of document
