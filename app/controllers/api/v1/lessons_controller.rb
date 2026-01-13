# app/controllers/api/v1/lessons_controller.rb

class Api::V1::LessonsController < ApplicationController
  before_action :authenticate_user!

  # GET /api/v1/lessons/:module_num/:lesson_num
  def show
    module_num = params[:module_num].to_i
    lesson_num = params[:lesson_num].to_i

    lesson_text = LessonContentService.get_lesson_text(module_num, lesson_num)
    lesson_title = LessonContentService.get_lesson_title(module_num, lesson_num)

    audio_url = case [module_num, lesson_num]
    when [1, 1]
      @current_user.lesson_1_1_audio_url
    else
      nil
    end

    render json: {
      success: true,
      lesson: {
        module: module_num,
        lesson: lesson_num,
        title: lesson_title,
        text: lesson_text,
        audio_url: audio_url,
        voice_ready: @current_user.voice_ready?
      }
    }
  end
end