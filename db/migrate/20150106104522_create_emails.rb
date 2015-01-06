class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :receiver_id, :sender_id
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
