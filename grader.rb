require 'rubygems'
require 'treetop'

base_path = File.expand_path(File.dirname(__FILE__))

require File.join(base_path, 'nodes.rb')

Treetop.load(File.join(base_path, 'commentgrades.tt'))

# Extend generated parser
class CommentGradesParser
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


class Grade
  attr_reader :name, :max, :is_negative

  def initialize(name, max, opts={})
    @name = name.to_s
    @max = max
    @is_negative = opts[:is_negative] || false
    reset
  end

  def reset
    # running value and maximum
    @r_val = 0
    @r_max = 0
    @val = nil
  end

  def consume(node)
    n = node.numerator
    return if n.nil?
    @r_val += n.to_f
    n = node.denominator
    return if n.nil?
    @r_max += n.to_f
  end

  def val
    return @val if not @val.nil?
    val = 0
    if @is_negative
      val = @max + @r_val
      raise Exception, "Overdeducted for #{@name}" \
        if val < 0
    else
      raise Exception, "Mismatch for #{@name}: #{@max} != #{@r_max}" \
        if @max != @r_max
      val = @r_val
    end
    @val = val
    return @val
  end

  def inspect
    "#{@name}: #{val}/#{@max}"
  end
end

class Grader
  attr_reader :components

  def initialize
    @parser = CommentGradesParser.new
    @components = {}
  end

  def parse_file(filename)
    open(filename, 'r') do |f|
      @parser.parse(f.read)
    end
    collect_grades
  end

  def <<(grade_args)
    name, _ = grade_args
    @components[name] = Grade.new(*grade_args)
  end

  def collect_grades
    @parser.walk_component_grades(@components)
  end

  def each(&block)
    (@components || {}).each(&block)
  end

  def inspect
    result = []
    each do |component, grade|
      result << grade.inspect
    end
    result.join "\n"
  end
end
