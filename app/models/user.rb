# app/models/user.rb

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  # Voice cloning status scopes
  scope :voice_cloning_pending, -> { where(voice_cloning_status: 'pending') }
  scope :voice_cloning_completed, -> { where(voice_cloning_status: 'completed') }
  scope :voice_cloning_failed, -> { where(voice_cloning_status: 'failed') }

  # Check if voice cloning is ready
  def voice_ready?
    voice_cloning_status == 'completed' && elevenlabs_voice_id.present?
  end

  # Check if lesson audio is generated
  def lesson_audio_ready?(module_num, lesson_num)
    case [module_num, lesson_num]
    when [1, 1]
      lesson_1_1_audio_url.present?
    else
      false
    end
  end
end