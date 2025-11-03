class ChangeStartTimeDefaultInScheduleItems < ActiveRecord::Migration[7.1]
  def up
    change_column_default :schedule_items, :start_time, from: nil, to: -> { "CURRENT_TIME" }
    
    ScheduleItem.where(start_time: nil).update_all(start_time: Time.parse("19:00"))
  end

  def down
    change_column_default :schedule_items, :start_time, from: -> { "CURRENT_TIME" }, to: nil
  end
end
