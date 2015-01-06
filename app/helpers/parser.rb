# TOKEN = "dd4cf85cd0ee9ffb448340bc66507619"
TOKEN = "4a4ad4e690121617b837a13e60e36736"
# TOKEN = "5b8d81de9ec2dee5ae3de9c5dd160dff"

helpers do
  def get_emails(user)
    query = "?api_token="
    uri = URI('http://dbc-mail.herokuapp.com/api/' + user.email_address + '/messages' + query + TOKEN)
    response = Net::HTTP.get_response(uri)
    case response.code
    when '200'
      if count_emails(user).to_i > 0
        inbox = Hash.from_xml(response.body)
        parse_into_objects(inbox["messages"])
      end
      emails = Email.where(receiver_id: user.id).to_json
    when '404'
      "email address does not exist"
    when '429'
      "too many requests, please try again later"
    when '502'
      "planned failure"
    end
  end

  def count_emails(user)
    query = "count?last_id=" + Email.most_recent_id(user).to_s + "&api_token="
    uri = URI('http://dbc-mail.herokuapp.com/api/' + user.email_address + '/messages/' + query + TOKEN)
    response = Net::HTTP.get_response(uri)
    response.body
    # http://dbc-mail.herokuapp.com/api/supermonkey@mafia.com/messages/count?last_id=10&api_token=dd4cf85cd0ee9ffb448340bc66507619
  end

  def parse_into_objects(xml_string)
    xml_string.each do |hash|
      receiver = User.find_or_create({id: hash["email_address_id"]})
      sender = User.find_or_create({email_address: hash["from"]})
      email = Email.create!(id: hash["id"], subject: hash["subject"], receiver: receiver, sender: sender, body: hash["body"])
    end
  end
end
