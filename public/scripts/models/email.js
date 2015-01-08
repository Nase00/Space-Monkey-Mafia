function Email(args) {
  this.id = args.id;
  this.receiver_id = args.receiver_id;
  this.from = args.from;
  this.subject = args.subject;
  this.body = args.body;
  this.created_at = args.created_at;
}

Email.all = function() {
  return $.get('/users/supermonkey@mafia.com/email');
}

// Email.fetch = function(id) {
//   return $.get('/users/supermonkey@mafia.com/email'+id);
// }
