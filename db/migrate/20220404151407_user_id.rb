class UserId < ActiveRecord::Migration[7.0]
  def change
    change_table :tweets do |t|
      t.references :user
    end
  end
end
