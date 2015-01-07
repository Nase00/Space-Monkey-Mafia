# XXX_YOLO_XXX_ANARCHY4LYFE
# TOKEN = "dd4cf85cd0ee9ffb448340bc66507619"
# TOKEN = "4db3d893163a766319c0560a29da57ae"
# TOKEN = "4a4ad4e690121617b837a13e60e36736"
TOKEN = "5b8d81de9ec2dee5ae3de9c5dd160dff"

helpers do
  def get_emails(user)
    query = "?api_token="
    uri = URI('http://dbc-mail.herokuapp.com/api/' + user.email_address + '/messages' + query + TOKEN)
    response = Net::HTTP.get_response(uri)
    case response.code
    when '200'
      until new_emails(user) == 0 # should fetch emails until API says no new emails to check
        inbox = Hash.from_xml(response.body)
        parse_into_objects(inbox["messages"], new_emails(user))
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

  def new_emails(user)
    query = "count?last_id=" + user.most_recent_received_email_id.to_s + "&api_token="
    uri = URI('http://dbc-mail.herokuapp.com/api/' + user.email_address + '/messages/' + query + TOKEN)
    response = Net::HTTP.get_response(uri)
    hash = Hash.from_xml(response.body)

    return hash["hash"]["count"].to_i
  end

  def parse_into_objects(xml_string, num)
    xml_string.each do |hash|
      receiver = User.find_or_create({id: hash["email_address_id"]})
      sender = User.find_or_create({email_address: hash["from"]})
      Email.find_or_create_by(id: hash["id"]) do |email|
        email.subject = hash["subject"]
        email.receiver = receiver
        email.sender = sender
        subject = hash["subject"]
        body = hash["body"]
      end
    end
  end
end
