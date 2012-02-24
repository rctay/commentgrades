module CommentGrades
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
end
