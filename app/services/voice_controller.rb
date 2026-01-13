module Api
  module V1
    class VoiceController < ApplicationController
      # POST /api/v1/voice/clone
      def clone
        # Ses dosyasını base64'ten kaydet
        audio_data = Base64.decode64(params[:audio_base64])
        audio_path = Rails.root.join('tmp', "voice_#{SecureRandom.hex(8)}.m4a")
        File.open(audio_path, 'wb') { |f| f.write(audio_data) }
        
        # ElevenLabs ile klonla
        service = ElevenlabsService.new
        voice_id = service.clone_voice(
          name: "User_#{params[:user_id]}",
          audio_file_path: audio_path.to_s
        )
        
        if voice_id
          render json: { 
            success: true, 
            voice_id: voice_id 
          }
        else
          render json: { 
            success: false, 
            error: 'Voice cloning failed' 
          }, status: :unprocessable_entity
        end
      ensure
        File.delete(audio_path) if audio_path && File.exist?(audio_path)
      end
    end
  end
end