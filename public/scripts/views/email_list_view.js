function EmailListView(emails) {
  this.emails = emails;
  this.template = _.template($("#template").html());
  this.$element = $("<div></div>");
}

EmailListView.prototype.render = function() {
  this.$element.html(this.template());

  this.emails.forEach(function(email) {
    var emailView = new EmailRowView(email)
    this.$element.find("#emails").append(emailView.render());
  }, this);

  return this.$element;
}
