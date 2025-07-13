RailsAdmin.config do |config|
  config.asset_source = :sprockets

  config.model 'SiteConfig' do
    label 'サイト設定'
    label_plural 'サイト設定'

    # レコード個別の表示をカスタマイズする場合
    # SiteConfigのインスタンス（レコード）が自身をどう表示するか定義
    # 例えば、IDを表示しないようにしたい場合など
    # object_label_method do
    #   :instagram_text # または :id, またはメソッドを定義
    # end
    # 例として、レコードが一つしかないなら「Instagram設定」と表示したい場合
    # object_label_method do
    #   'Instagram設定'
    # end
  end

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    # import
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Category' do
    list do
      field :name
    end
  end

  config.model 'Post' do
    edit do
      field :title do
        required true
      end
      field :content do
        required true
      end
      field :category do
        required true
      end
      field :date do
        required true
      end
      field :author do
        required true
      end
    end
  end
end
