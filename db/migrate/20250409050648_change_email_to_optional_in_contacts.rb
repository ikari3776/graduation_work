class ChangeEmailToOptionalInContacts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :contacts, :email, true
  end
end
