class CreatePronunciationAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :pronunciation_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.text :expected_text
      t.text :actual_text
      t.integer :score
      t.json :mistakes

      t.timestamps
    end
  end
end
