class RemoveUserFromTweets < ActiveRecord::Migration[7.0]
  def change
    change_table :tweets do |t|
      t.remove :user
    end
  end
end
