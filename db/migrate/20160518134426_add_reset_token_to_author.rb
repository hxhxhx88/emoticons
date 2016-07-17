class AddResetTokenToAuthor < ActiveRecord::Migration
  def change
    add_column :authors, :reset_token, :string
    add_column :authors, :reset_token_expire, :datetime

  end
end
