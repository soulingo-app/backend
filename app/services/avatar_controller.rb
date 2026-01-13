module Api
  module V1
    class AvatarController < ApplicationController
      # POST /api/v1/avatar/create
      def create
        service = DidService.new
        
        video_id = service.create_video(
          image_url: params[:image_url],
          audio_url: params[:audio_url]
        )
        
        if video_id
          render json: { 
            success: true, 
            video_id: video_id 
          }
        else
          render json: { 
            success: false, 
            error: 'Video creation failed' 
          }, status: :unprocessable_entity
        end
      end
      
      # GET /api/v1/avatar/status/:video_id
      def status
        service = DidService.new
        result = service.get_video_status(params[:video_id])
        
        if result
          render json: result
        else
          render json: { error: 'Status check failed' }, status: :not_found
        end
      end
    end
  end
end