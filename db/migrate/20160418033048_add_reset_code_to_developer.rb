class AddResetCodeToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :reset_code, :string
    add_column :developers, :reset_code_validation, :datetime
  end
end
