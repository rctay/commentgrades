require 'rubygems'
require 'treetop'

require 'commentgrades/nodes'

base_path = File.expand_path(File.dirname(__FILE__))

Treetop.load(File.join(base_path, 'c_source'))

# Extend generated parser
module CommentGrades
  module Parser
    attr_reader :result

    def parse(*args)
      @result = super(*args)
    end

    def walk_component_grades(grades)
      return if @result.nil?
      do_walk_component_grades(@result, grades)
    end

  private
    def do_walk_component_grades(node, grades)
      if node.is_a? CommentGrades::ComponentGrade
        grade = grades[node.component.text_value.to_sym]
        raise Exception, "Unknown component #{node.component}" \
          if grade.nil?
        grade.consume(node.grade)
        # no nested component grades, so don't traverse children
        return
      end
      return if node.elements.nil?
      node.elements.each {|node|
        do_walk_component_grades(node, grades)
      }
    end
  end

  class CSourceParser
    include Parser
  end
end
