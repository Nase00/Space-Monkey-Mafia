class Email < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  def self.most_recent_id(user)
    self.where(receiver_id: user.id).order(:created_at).first.id
  end
end
