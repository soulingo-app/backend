class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :elevenlabs_voice_id
      t.string :did_avatar_id
      t.string :audio_file_url
      t.string :image_file_url
      t.integer :recording_duration

      t.timestamps
    end
  end
end
