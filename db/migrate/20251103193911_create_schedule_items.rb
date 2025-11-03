class CreateScheduleItems < ActiveRecord::Migration[7.1]
  def change
    create_table :schedule_items do |t|
      t.references :meeting, null: false, foreign_key: true
      t.time :start_time, null: false
      t.integer :duration_minutes, null: false, default: 10
      t.string :role, null: false
      t.string :speaker
      t.text :notes
      t.integer :position

      t.timestamps
    end

    add_index :schedule_items, [:meeting_id, :position]
  end
end
