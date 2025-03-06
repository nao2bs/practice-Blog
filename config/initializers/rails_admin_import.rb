RailsAdmin.config do |config|
  # REQUIRED:
  # Include the import action
  # See https://github.com/sferik/rails_admin/wiki/Actions
  config.actions do
    all
    import
  end

  # Optional:
  # Configure global RailsAdminImport options
  # Configure pass filename to records hashes
  # config.configure_with(:import) do |config|
  #   config.logging = true
  #   config.pass_filename = true
  # end

  # Optional:
  # Configure model-specific options using standard RailsAdmin DSL
  # See https://github.com/sferik/rails_admin/wiki/Railsadmin-DSL
  # config.model 'User' do
  #   import do
  #     include_all_fields
  #     exclude_fields :secret_token
  #   end
  # end

  config.model 'Post' do
    import do
      include_all_fields
      exclude_fields :created_at, :updated_at
    end
  end
end
