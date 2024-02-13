class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      # t.references :user, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.text :content
      t.boolean :read

      t.timestamps
    end
    # add_column :notifications, :comment_id, :integer
    # add_index :notifications, :comment_id
  end
end
