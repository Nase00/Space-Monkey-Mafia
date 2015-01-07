class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :receiver_id
      t.string :from
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
