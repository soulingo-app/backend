class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.string :lesson_id
      t.string :title
      t.text :content
      t.string :level
      t.string :lesson_type

      t.timestamps
    end
    add_index :lessons, :lesson_id, unique: true
  end
end
