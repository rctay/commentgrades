require 'commentgrades'

class Grade
  attr_reader :name, :max, :is_negative
  attr_reader :r_val

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
      val = @r_val
      if @max != @r_max
        cmp = @r_max < @max ? "is below" : "exceeds"
        raise Exception, "Mismatch for #{@name}: " \
          "#{@r_max} #{cmp} #{@max}"
      end
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
    @parser = CommentGrades::CSourceParser.new
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
