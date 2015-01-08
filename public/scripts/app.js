var App = {
  start: function() {
    this.allEmails();
    this.$container = $("#content");
  },

  displayHtml: function(element) {
    this.$container.html(element);
  },

  allEmails: function() {
    Email.all().done(function(emails) {
      var listView = new EmailListView(emails);
      var listHtml = listView.render();
      this.displayHtml(listHtml);
    }.bind(this));
  }
};

$(document).ready(function() {
  App.start();
});
