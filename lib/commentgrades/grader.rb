require 'commentgrades/parser/parser'
require 'commentgrades/grades'

module CommentGrades
  class Grader
    attr_reader :components

    def initialize
      @parser = Parser::CSourceParser.new
      @final_grade = Grade.make(:final, 0)
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
      @components[name] = Grade.make(*grade_args)
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

    def render(kls)
      kls.render(self, @final_grade)
    end

    def inspect
      require 'commentgrades/render/default'
      render(Render::Default)
    end

    # provides a convenient "main()" - parses and prints grades
    def main(files)
      files.each do |filename|
        parse_file(filename)
        p self
      end
    end
  end
end
