# db/migrate/TIMESTAMP_add_lesson_audio_to_users.rb

class AddLessonAudioToUsers < ActiveRecord::Migration[8.1]
  def change
    # Klonlanmış ses ile üretilen ders sesleri
    add_column :users, :lesson_1_1_audio_url, :string
    add_column :users, :lesson_1_1_generated_at, :datetime
    
    # Ses klonlama durumu
    add_column :users, :voice_cloning_status, :string, default: 'pending'
    # possible values: pending, processing, completed, failed, completed_with_errors
  end
end