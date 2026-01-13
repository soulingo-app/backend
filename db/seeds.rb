puts "🌱 Seeding lessons..."

Lesson.destroy_all

lessons_data = [
  {
    lesson_id: 'a1_l1',
    title: 'Introduction & Daily Routine',
    content: 'Hola. Me llamo Ana. Soy estudiante. Estudio todos los días. Soy de Turquía. Vivo en Ankara.',
    level: 'A1',
    lesson_type: 'lecture_repetition'
  },
  {
    lesson_id: 'a1_l2',
    title: 'Simple Questions',
    content: 'Q: ¿Cuántos dedos tienes? A: Diez.',
    level: 'A1',
    lesson_type: 'question_answer'
  }
]

lessons_data.each do |lesson_data|
  Lesson.create!(lesson_data)
  puts "✅ Created lesson: #{lesson_data[:title]}"
end

puts "🎉 Seeding completed! #{Lesson.count} lessons created."