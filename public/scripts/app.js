var App = {
  start: function() {
    var request = $.get('/users/supermonkey@mafia.com/email');
    request.done(function(response) {
      $('#content').append(response)
    });
  }
};

$(document).ready(function() {
  App.start();
});
