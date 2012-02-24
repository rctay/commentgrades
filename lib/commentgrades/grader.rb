require 'commentgrades/parser/parser'
require 'commentgrades/grades'

module CommentGrades
  class Grader
    attr_reader :components

    def initialize
      @parser = Parser::CSourceParser.new
      @final_grade = Grade.new(:final, 0)
      @components = {}
    end

    def parse_file(filename)
      open(filename, 'r') do |f|
        @parser.parse(f.read)
      end

      @components.each_value {|grade| grade.reset }
      @final_grade.reset

      collect_grades
    end

    def <<(grade_args)
      name, _ = grade_args
      @components[name] = Grade.new(*grade_args)
    end

    def collect_grades
      @components[:final] = @final_grade
      @parser.walk_component_grades(@components)
      @components.delete :final
      nil
    end

    def each(&block)
      (@components || {}).each(&block)
    end

    def inspect
      result = []
      final_n = final_d = 0
      each do |component, grade|
        result << grade.inspect
        final_n += grade.val
        final_d += grade.max
      end
      val = @final_grade.r_val
      if val != 0
        final_n += val
        result << "final #{val}"
      end
      result << "final: #{final_n}/#{final_d}"
      result.join "\n"
    end
  end
end
