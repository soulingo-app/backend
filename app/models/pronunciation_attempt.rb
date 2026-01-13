class PronunciationAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  
  validates :expected_text, :actual_text, presence: true
end