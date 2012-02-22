require 'rubygems'
require 'treetop'

base_path = File.expand_path(File.dirname(__FILE__))

require File.join(base_path, 'nodes.rb')

Treetop.load(File.join(base_path, 'commentgrades.tt'))

class CommentGradesParser
  attr_reader :result

  def parse(*args)
    @result = super(*args)
  end

  def walk_component_grades
    return if @result.nil?
    do_walk_component_grades(@result)
  end

private
  def do_walk_component_grades(node)
    if node.is_a? CommentGrades::ComponentGrade
      p node
      # no nested component grades, so don't traverse children
      return
    end
    return if node.elements.nil?
    node.elements.each {|node|
      do_walk_component_grades(node)
    }
  end
end
