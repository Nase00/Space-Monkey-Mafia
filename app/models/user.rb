class User < ActiveRecord::Base
  has_many :received_emails, class_name: "Email", foreign_key: :receiver_id
  has_many :sent_emails, class_name: "Email", foreign_key: :sender_id

  def self.find_or_create(hash)
    User.find_or_create_by(hash) do |user|
      user.name = Faker::Name.name
    end
  end
end
