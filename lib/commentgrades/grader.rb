require 'commentgrades/parser/parser'
require 'commentgrades/grades'
require 'commentgrades/render/default'

module CommentGrades
  class Grader
    attr_reader :components
    attr_accessor :renderer, :ctxt

    def initialize
      @parser = Parser::CSourceParser.new
      @final_grade = Grade.make(:final, 0)
      @components = {}
      @renderer = Render::Default.new
      @ctxt = {}
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

    def render(rndr=nil)
      rndr ||= @renderer
      rndr.render(rndr.template, build_context)
    end

    def inspect
      render
    end

    def build_context()
      ctxt = {}
      components = []
      final_n = final_d = 0
      each do |component, grade|
        components << {
          :name => component,
          :grade => grade.val,
          :outof => grade.max,
        }
        final_n += grade.val
        final_d += grade.max
      end
      ctxt[:components] = components

      val = @final_grade.r_val
      if val != 0
        final_n += val
        ctxt[:final_adjustment] = {
          :adjustment => @final_grade.r_val
        }
      end

      ctxt[:grade] = final_n
      ctxt[:outof] = final_d
      ctxt.merge! @ctxt
      return ctxt
    end

    # provides a convenient "main()" - parses and prints grades
    def main(args=ARGV)
      args.each do |arg|
        opts = yield arg
        filename = opts.delete :filename
        @ctxt = opts
        parse_file(filename)
        p self
      end
    end
  end
end
