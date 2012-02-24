module CommentGrades
  module Render
    class Default
      def self.render(grader, final_grade)
        result = []
        final_n = final_d = 0
        grader.each do |component, grade|
          result << grade.inspect
          final_n += grade.val
          final_d += grade.max
        end
        val = final_grade.r_val
        if val != 0
          final_n += val
          result << "final #{val}"
        end
        result << "final: #{final_n}/#{final_d}"
        result.join "\n"
      end
    end
  end
end
