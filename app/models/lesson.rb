class Lesson < ApplicationRecord
  validates :lesson_id, presence: true, uniqueness: true
  validates :title, :content, :level, presence: true
  
  has_many :user_lessons, dependent: :destroy
  has_many :users, through: :user_lessons
  has_many :pronunciation_attempts, dependent: :destroy
end