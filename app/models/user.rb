class User < ActiveRecord::Base
  has_many :received_emails, class_name: "Email", foreign_key: :receiver_id
  has_many :sent_emails, class_name: "Email", foreign_key: :sender_id

  def show_emails
    Email.where(receiver_id: self.id).to_json
  end

  def get_emails
    if self.new_emails > 0
      query = "?api_token="
      uri = URI('http://dbc-mail.herokuapp.com/api/' + self.email_address + '/messages' + query + TOKEN)
      response = Net::HTTP.get_response(uri)
      case response.code
      when '200' # should fetch emails until API says no new emails to check
        inbox = Hash.from_xml(response.body)
        Parser.into_objects(inbox["messages"])
        self.show_emails
      when '404'
        "email address does not exist"
      when '429'
        "too many requests, please try again later"
      when '502'
        "planned failure"
      end
    else
      self.show_emails
    end
  end

  def new_emails
    query = "count?last_id=" + self.most_recent_received_email_id.to_s + "&api_token="
    uri = URI('http://dbc-mail.herokuapp.com/api/' + self.email_address + '/messages/' + query + TOKEN)
    response = Net::HTTP.get_response(uri)
    hash = Hash.from_xml(response.body)

    return hash["hash"]["count"].to_i
  end

  def self.find_or_create(hash)
    User.find_or_create_by(hash) do |user|
      user.name = Faker::Name.name
    end
  end

  def most_recent_received_email_id
    if self.received_emails.empty?
      0
    else
      self.received_emails.order(:created_at).first.id
    end
  end
end
