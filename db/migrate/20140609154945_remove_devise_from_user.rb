class RemoveDeviseFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :email, :string, default: '', null: false
    remove_column :users, :encrypted_password, :string, default: '', null: false
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :sign_in_count, :datetime, default: 0, null: false
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string
    add_column :users, :password_digest, :string
  end
end
