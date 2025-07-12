class CreateSiteConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :site_configs do |t|
      t.string :instagram_text
      t.string :instagram_link

      t.timestamps
    end
  end
end
