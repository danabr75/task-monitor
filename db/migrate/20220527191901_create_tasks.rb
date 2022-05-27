class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :token
      t.datetime :last_heartbeat_at
      t.datetime :sent_alert_notification_at
      t.timestamps
    end
  end
end
