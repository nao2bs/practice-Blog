ActiveAdmin.register Comment do
    permit_params :content, :post_id, :created_at

    index do
      selectable_column
      id_column
      column :content
      column :post, as: :simplemde_editor
      column :created_at
      actions
    end
  end
