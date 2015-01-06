helpers do
  def parse_into_objects(xml_string)
    xml_string.each do |hash|
      receiver = User.find_or_create({id: hash["email_address_id"]})
      sender = User.find_or_create({email_address: hash["from"]})
      email = Email.create!(id: hash["id"], subject: hash["subject"], receiver: receiver, sender: sender, body: hash["body"])
    end
  end
end
