class AddVersionAndDownloadUrlToAdminMessage < ActiveRecord::Migration
  def change
    add_column :admin_messages, :version, :string, default: nil
    add_column :admin_messages, :download_url, :string, default: nil
  end
end
