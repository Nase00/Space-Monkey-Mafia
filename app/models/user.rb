class User < ActiveRecord::Base
  has_many :received_emails, class_name: "Email", foreign_key: :receiver_id
  has_many :sent_emails, class_name: "Email", foreign_key: :sender_id

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
