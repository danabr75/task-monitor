class AddCustomInactiveAfterToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :inactive_after_mins, :integer
  end
end
