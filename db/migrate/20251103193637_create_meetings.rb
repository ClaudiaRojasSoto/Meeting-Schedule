class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.string :title, null: false
      t.date :date, null: false
      t.string :location
      t.text :notes
      t.string :meeting_type
      t.string :pdf_url

      t.timestamps
    end

    add_index :meetings, :date
  end
end
