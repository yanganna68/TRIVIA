class CreateQuizzes < ActiveRecord::Migration[5.1]
  def change
    create_table :quizzes do |t|
      t.string :category_name
      t.integer :category_id
      t.integer :challenge_id
      t.integer :user_score, default: 0
      t.integer :rival_score, default: 0
      t.timestamps
    end
  end
end
