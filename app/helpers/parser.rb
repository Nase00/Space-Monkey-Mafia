# XXX_YOLO_XXX_ANARCHY4LYFE
# TOKEN = "dd4cf85cd0ee9ffb448340bc66507619"
# TOKEN = "4db3d893163a766319c0560a29da57ae"
TOKEN = "4a4ad4e690121617b837a13e60e36736"
# TOKEN = "5b8d81de9ec2dee5ae3de9c5dd160dff"

helpers do
  module Parser
    def self.into_objects(xml_string)
      xml_string.each do |hash|
        receiver = User.find_by({id: hash["email_address_id"]})
        sender = User.find_by({email_address: hash["from"]})
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
end
