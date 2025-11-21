class AddBooleanToSiteConfig < ActiveRecord::Migration[7.0]
  def change
    add_column :site_configs, :published, :boolean, default: true, null: false
  end
end
