class CreateChallenges < ActiveRecord::Migration[5.1]
  def change
    create_table :challenges do |t|
      t.integer :user_id
      t.integer :rival_id, class: 'User'
      t.timestamps
    end
  end
end
