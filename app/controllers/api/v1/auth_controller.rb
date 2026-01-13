module Api
  module V1
    class AuthController < ApplicationController
      # POST /api/v1/auth/register
      def register
        Rails.logger.info "📝 Registration attempt: #{params[:email]}"
        
        # Ses dosyasını kaydet (base64'ten)
        audio_path = nil
        if params[:audio_base64].present?
          audio_data = Base64.decode64(params[:audio_base64])
          filename = "audio_#{SecureRandom.hex(8)}.m4a"
          audio_path = Rails.root.join('public', 'uploads', 'audio', filename)
          
          FileUtils.mkdir_p(File.dirname(audio_path))
          File.open(audio_path, 'wb') { |f| f.write(audio_data) }
          
          Rails.logger.info "🎤 Audio saved: #{filename}"
        end
        
        # Fotoğrafı kaydet (base64'ten)
        image_path = nil
        if params[:image_base64].present?
          image_data = Base64.decode64(params[:image_base64])
          filename = "image_#{SecureRandom.hex(8)}.jpg"
          image_path = Rails.root.join('public', 'uploads', 'images', filename)
          
          FileUtils.mkdir_p(File.dirname(image_path))
          File.open(image_path, 'wb') { |f| f.write(image_data) }
          
          Rails.logger.info "📷 Image saved: #{filename}"
        end
        
        # User oluştur
        user = User.new(
          email: params[:email],
          password: params[:password],
          audio_file_url: audio_path ? "/uploads/audio/#{File.basename(audio_path)}" : nil,
          image_file_url: image_path ? "/uploads/images/#{File.basename(image_path)}" : nil,
          recording_duration: params[:recording_duration]&.to_i
        )
        
        if user.save
          token = generate_token(user.id)
          Rails.logger.info "✅ User registered: #{user.email}"
          
          render json: { 
            success: true,
            message: 'Registration successful',
            user: user_response(user),
            token: token 
          }, status: :created
        else
          Rails.logger.error "❌ Registration failed: #{user.errors.full_messages}"
          render json: { 
            success: false,
            errors: user.errors.full_messages 
          }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/auth/login
      def login
        Rails.logger.info "🔐 Login attempt: #{params[:email]}"
        
        user = User.find_by(email: params[:email])
        
        if user&.authenticate(params[:password])
          token = generate_token(user.id)
          Rails.logger.info "✅ Login successful: #{user.email}"
          
          render json: { 
            success: true,
            message: 'Login successful',
            user: user_response(user),
            token: token 
          }
        else
          Rails.logger.error "❌ Login failed: Invalid credentials"
          render json: { 
            success: false,
            error: 'Invalid email or password' 
          }, status: :unauthorized
        end
      end
      
      # GET /api/v1/auth/me (Token ile kullanıcı bilgilerini getir)
      # app/controllers/api/v1/auth_controller.rb - sadece me methodunu güncelle

      def me
        render json: {
          success: true,
          user: {
            id: @current_user.id,
            email: @current_user.email,
            audio_file_url: @current_user.audio_file_url,
            image_file_url: @current_user.image_file_url,
            recording_duration: @current_user.recording_duration,
            
            # Voice cloning bilgileri
            elevenlabs_voice_id: @current_user.elevenlabs_voice_id,
            voice_cloning_status: @current_user.voice_cloning_status,
            voice_ready: @current_user.voice_ready?,
            
            # Ders sesleri
            lessons: {
              module_1: {
                lesson_1: {
                  audio_url: @current_user.lesson_1_1_audio_url,
                  generated_at: @current_user.lesson_1_1_generated_at,
                  ready: @current_user.lesson_audio_ready?(1, 1)
                }
              }
            }
          }
        }
      end
      
      private
      
      def generate_token(user_id)
        JWT.encode(
          { user_id: user_id, exp: 7.days.from_now.to_i }, 
          Rails.application.credentials.secret_key_base,
          'HS256'
        )
      end
      
      def user_response(user)
        {
          id: user.id,
          email: user.email,
          audio_file_url: user.audio_file_url ? "http://#{request.host}:#{request.port}#{user.audio_file_url}" : nil,
          image_file_url: user.image_file_url ? "http://#{request.host}:#{request.port}#{user.image_file_url}" : nil,
          recording_duration: user.recording_duration,
          elevenlabs_voice_id: user.elevenlabs_voice_id,
          did_avatar_id: user.did_avatar_id,
          created_at: user.created_at
        }
      end
    end
  end
end