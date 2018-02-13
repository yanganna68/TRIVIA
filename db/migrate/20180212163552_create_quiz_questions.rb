class CreateQuizQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :quiz_questions do |t|
      t.integer :question_id
      t.integer :quiz_id
      t.timestamps
    end
  end
end
