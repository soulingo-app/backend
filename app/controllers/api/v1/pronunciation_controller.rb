module Api
  module V1
    class PronunciationController < ApplicationController
      # POST /api/v1/pronunciation/evaluate
      def evaluate
        expected_text = params[:expected_text]
        actual_text = params[:actual_text] || "Simulated transcription"
        
        score = calculate_similarity(expected_text, actual_text)
        mistakes = find_mistakes(expected_text, actual_text)
        
        render json: {
          score: score,
          mistakes: mistakes,
          feedback: generate_feedback(score)
        }
      end
      
      private
      
      def calculate_similarity(expected, actual)
        return 0 if expected.nil? || actual.nil?
        
        expected_words = expected.downcase.split
        actual_words = actual.downcase.split
        
        matches = (expected_words & actual_words).length
        total = expected_words.length
        
        ((matches.to_f / total) * 100).round
      end
      
      def find_mistakes(expected, actual)
        [
          {
            word: "ejemplo",
            expected_pronunciation: "e-HEM-plo",
            actual_pronunciation: "e-JEM-plo",
            timestamp: 1500
          }
        ]
      end
      
      def generate_feedback(score)
        case score
        when 90..100
          "Excellent pronunciation!"
        when 70..89
          "Good job! Pay attention to stress patterns."
        when 50..69
          "Keep practicing. Focus on vowel sounds."
        else
          "Try again. Listen carefully to the audio."
        end
      end
    end
  end
end