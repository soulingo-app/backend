# app/services/lesson_content_service.rb

class LessonContentService
  # Modül 1 - Ders 1 İçeriği
  LESSON_1_1 = {
    title: "Módulo 1 - Lección 1: Presentación Personal",
    text: "Hola. Me llamo Ana. Soy estudiante. Estudio todos los días. Soy de Turquía. " \
          "Vivo en Ankara. " \
          "Me levanto temprano. Bebo agua. Voy a la escuela. Vuelvo a casa. Estudio español."
  }.freeze

  def self.get_lesson_text(module_num, lesson_num)
    case [module_num, lesson_num]
    when [1, 1]
      LESSON_1_1[:text]
    else
      nil
    end
  end

  def self.get_lesson_title(module_num, lesson_num)
    case [module_num, lesson_num]
    when [1, 1]
      LESSON_1_1[:title]
    else
      "Módulo #{module_num} - Lección #{lesson_num}"
    end
  end
end