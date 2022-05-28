class AddingIgnorableWindowsToTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :ignorable_windows do |t|
      t.string :start_time
      t.string :stop_time
      t.references :task, index: true
      t.timestamps
    end
  end
end
