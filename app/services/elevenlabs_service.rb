# app/services/elevenlabs_service.rb

class ElevenlabsService
  BASE_URL = "https://api.elevenlabs.io/v1"
  API_KEY = ENV['ELEVENLABS_API_KEY']

  # Ses klonlama - URL'den sesi çekip ElevenLabs'e gönder
  def self.clone_voice_from_url(audio_url, voice_name)
    Rails.logger.info "🎙️ Cloning voice from URL: #{audio_url}"
    
    # 1. Ses dosyasını indir
    audio_response = HTTParty.get(audio_url, timeout: 30)
    unless audio_response.success?
      Rails.logger.error "❌ Failed to download audio: #{audio_response.code}"
      return nil
    end

    Rails.logger.info "✅ Audio downloaded: #{audio_response.body.size} bytes"

    # 2. Geçici dosya oluştur
    temp_file = Tempfile.new(['voice', '.m4a'])
    temp_file.binmode
    temp_file.write(audio_response.body)
    temp_file.close

    # 3. ElevenLabs'e gönder
    url = "#{BASE_URL}/voices/add"
    
    require 'net/http'
    require 'uri'

    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request['xi-api-key'] = API_KEY

    # Multipart form data oluştur
    boundary = "----WebKitFormBoundary#{SecureRandom.hex(16)}"
    request['Content-Type'] = "multipart/form-data; boundary=#{boundary}"

    # Body oluştur
    body = []
    
    # Name field
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"name\"\r\n\r\n"
    body << "#{voice_name}\r\n"
    
    # Description field
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"description\"\r\n\r\n"
    body << "Voice clone for #{voice_name}\r\n"
    
    # Files field (audio file)
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"files\"; filename=\"voice.m4a\"\r\n"
    body << "Content-Type: audio/mp4\r\n\r\n"
    body << File.binread(temp_file.path)
    body << "\r\n"
    
    # Labels (optional)
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"labels\"\r\n\r\n"
    body << "{\"accent\":\"spanish\",\"use_case\":\"language_learning\"}\r\n"
    
    # End boundary
    body << "--#{boundary}--\r\n"

    request.body = body.join

    # HTTP isteği gönder
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 120
    http.open_timeout = 30

    response = http.request(request)

    # Geçici dosyayı sil
    temp_file.unlink

    if response.code == '200'
      result = JSON.parse(response.body)
      voice_id = result['voice_id']
      Rails.logger.info "✅ ElevenLabs Voice Created: #{voice_id}"
      voice_id
    else
      Rails.logger.error "❌ ElevenLabs Error: #{response.code} - #{response.body}"
      nil
    end
  rescue => e
    Rails.logger.error "❌ ElevenLabs Clone Exception: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    temp_file&.unlink
    nil
  end

  # Text-to-Speech - Klonlanmış ses ile konuştur
  def self.text_to_speech(voice_id, text, language = 'es')
    Rails.logger.info "🗣️ TTS: voice_id=#{voice_id}, text_length=#{text.length}"
    
    url = "#{BASE_URL}/text-to-speech/#{voice_id}"
    
    response = HTTParty.post(
      url,
      headers: {
        'xi-api-key' => API_KEY,
        'Content-Type' => 'application/json'
      },
      body: {
        text: text,
        model_id: "eleven_multilingual_v2",
        voice_settings: {
          stability: 0.5,
          similarity_boost: 0.75,
          style: 0.0,
          use_speaker_boost: true
        }
      }.to_json,
      timeout: 120
    )

    if response.success?
      Rails.logger.info "✅ TTS Success (#{response.body.size} bytes)"
      response.body
    else
      Rails.logger.error "❌ TTS Error: #{response.code} - #{response.body}"
      nil
    end
  rescue => e
    Rails.logger.error "❌ TTS Exception: #{e.message}"
    nil
  end

  # Voice bilgilerini al
  def self.get_voice(voice_id)
    url = "#{BASE_URL}/voices/#{voice_id}"
    
    response = HTTParty.get(
      url,
      headers: {
        'xi-api-key' => API_KEY
      }
    )

    response.success? ? response.parsed_response : nil
  rescue => e
    Rails.logger.error "❌ Get Voice Exception: #{e.message}"
    nil
  end

  # Voice ID'yi sil
  def self.delete_voice(voice_id)
    url = "#{BASE_URL}/voices/#{voice_id}"
    
    response = HTTParty.delete(
      url,
      headers: {
        'xi-api-key' => API_KEY
      }
    )

    if response.success?
      Rails.logger.info "✅ Voice deleted: #{voice_id}"
      true
    else
      Rails.logger.error "❌ Delete voice failed: #{response.body}"
      false
    end
  rescue => e
    Rails.logger.error "❌ Delete Voice Exception: #{e.message}"
    false
  end
end