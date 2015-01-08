function EmailRowView(email) {
  this.email = email;
  this.$element = $("<div></div>");
  this.template = _.template($("#content").html());
}

EmailRowView.prototype.render = function() {
  this.$element.html(this.template(this.templateData()));

  return this.$element;
}

EmailRowView.prototype.templateData = function() {
  return {
    subject: this.email.subject,
    from: this.email.from
  }
}
