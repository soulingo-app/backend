class CloneVoiceJob < ApplicationJob
  queue_as :default

  def perform(user_id, text)
    user = User.find(user_id)
    return unless user.voice_sample_url

    audio = GradioTtsService.text_to_speech_with_voice_clone(
      text,
      user.voice_sample_url
    )

    return unless audio

    user.update!(
      lesson_audio: Base64.strict_encode64(audio)
    )
  end
end
