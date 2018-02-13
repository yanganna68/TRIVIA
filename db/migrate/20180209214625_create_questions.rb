class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.integer :category_id
      t.string :question_text
      t.string :correct_answer
      t.string :wrong_answer_1
      t.string :wrong_answer_2
      t.string :wrong_answer_3
      t.timestamps
    end
  end
end
