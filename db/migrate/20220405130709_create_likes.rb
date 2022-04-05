class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.belongs_to :tweet
      t.belongs_to :user
      t.timestamps
    end
  end
end
