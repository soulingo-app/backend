class CreateUserLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :user_lessons do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.string :audio_url
      t.string :video_url
      t.string :status

      t.timestamps
    end
  end
end
