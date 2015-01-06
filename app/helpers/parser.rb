TOKEN = "dd4cf85cd0ee9ffb448340bc66507619"

helpers do
  def get_emails(user)
    query = "?api_token="
    uri = URI('http://dbc-mail.herokuapp.com/api/' + user.email_address + '/messages' + query + TOKEN)
    response = Net::HTTP.get_response(uri)
    case response.code
    when '200'
      # count_emails(user)
      inbox = Hash.from_xml(response.body)
      parse_into_objects(inbox["messages"])
      emails = Email.where(receiver_id: user.id).to_json

    when '404'
      "email address does not exist"
    when '429'
      "too many requests, please try again later"
    when '502'
      "planned failure"
    end
  end

  # def count_emails(user)
  #   token = "?api_token="
  #   uri = URI('http://dbc-mail.herokuapp.com/api/' + user.email_address + '/messages' + token)
  #   response = Net::HTTP.get_response(uri)
  #   # http://dbc-mail.herokuapp.com/api/supermonkey@mafia.com/messages/count?last_id=10&api_token=dd4cf85cd0ee9ffb448340bc66507619
  # end

  def parse_into_objects(xml_string)
    xml_string.each do |hash|
      receiver = User.find_or_create({id: hash["email_address_id"]})
      sender = User.find_or_create({email_address: hash["from"]})
      email = Email.create!(id: hash["id"], subject: hash["subject"], receiver: receiver, sender: sender, body: hash["body"])
    end
  end
end
