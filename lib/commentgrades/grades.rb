module CommentGrades
  class Grade
    attr_reader :name, :max
    attr_reader :r_val

    def self.make(name, max, opts={})
      kls = Grade
      if opts[:is_negative]
        kls = NegativeGrade
      end
      return kls.new(name, max)
    end

    def initialize(name, max)
      @name = name.to_s
      @max = max
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
      @val = _val()
      return @val
    end

    def inspect
      "#{@name}: #{val}/#{@max}"
    end
  
  protected
    def _val
      val = @r_val
      return val if @max == @r_max
      # from here, we prepare the error
      cmp = @r_max < @max ? "is below" : "exceeds"
      raise Exception, "Mismatch for #{@name}: " \
        "#{@r_max} #{cmp} #{@max}"
    end
  end

  # For negative marking
  class NegativeGrade < Grade
  protected
    def _val
      val = @max + @r_val
      raise Exception, "Overdeducted for #{@name}" \
        if val < 0
      return val
    end
  end
end
