# app/controllers/api/v1/users_controller.rb

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update_recording, :me]

  def update_recording
    audio_base64 = params[:audio_base64]
    image_base64 = params[:image_base64]
    duration = params[:recording_duration]

    Rails.logger.info "📤 Update Recording Request:"
    Rails.logger.info "  User: #{@current_user.email}"
    Rails.logger.info "  Audio: #{audio_base64.present? ? '✅' : '❌'}"
    Rails.logger.info "  Image: #{image_base64.present? ? '✅' : '❌'}"
    Rails.logger.info "  Duration: #{duration}"

    audio_url = nil
    image_url = nil

    # Ses dosyasını kaydet
    if audio_base64.present?
      audio_url = save_audio_file(audio_base64)
      Rails.logger.info "✅ Audio saved: #{audio_url}"
    end

    # Görüntü dosyasını kaydet
    if image_base64.present?
      image_url = save_image_file(image_base64)
      Rails.logger.info "✅ Image saved: #{image_url}"
    end

    # User'ı güncelle
    if @current_user.update(
      audio_file_url: audio_url,
      image_file_url: image_url,
      recording_duration: duration
    )
      # 🎙️ ElevenLabs'de ses klonla (background job'da)
      if audio_url.present?
        CloneVoiceJob.perform_later(@current_user.id)
        Rails.logger.info "🔄 Voice cloning job queued for user #{@current_user.id}"
      end

      render json: {
        success: true,
        user: {
          id: @current_user.id,
          email: @current_user.email,
          audio_file_url: @current_user.audio_file_url,
          image_file_url: @current_user.image_file_url,
          recording_duration: @current_user.recording_duration,
          elevenlabs_voice_id: @current_user.elevenlabs_voice_id,
          voice_cloning_status: @current_user.voice_cloning_status
        }
      }, status: :ok
    else
      render json: { 
        success: false, 
        error: 'Failed to update recording' 
      }, status: :unprocessable_entity
    end
  end

  private

  def save_audio_file(base64_data)
    return nil if base64_data.blank?

    begin
      decoded_data = Base64.decode64(base64_data)
      filename = "audio_#{SecureRandom.hex(12)}.m4a"
      filepath = Rails.root.join('public', 'uploads', 'audio', filename)
      
      FileUtils.mkdir_p(File.dirname(filepath))
      File.open(filepath, 'wb') { |file| file.write(decoded_data) }
      
      "#{request.base_url}/uploads/audio/#{filename}"
    rescue => e
      Rails.logger.error "❌ Audio save error: #{e.message}"
      nil
    end
  end

  def save_image_file(base64_data)
    return nil if base64_data.blank?

    begin
      decoded_data = Base64.decode64(base64_data)
      filename = "image_#{SecureRandom.hex(12)}.jpg"
      filepath = Rails.root.join('public', 'uploads', 'images', filename)
      
      FileUtils.mkdir_p(File.dirname(filepath))
      File.open(filepath, 'wb') { |file| file.write(decoded_data) }
      
      "#{request.base_url}/uploads/images/#{filename}"
    rescue => e
      Rails.logger.error "❌ Image save error: #{e.message}"
      nil
    end
  end
end