module CommentGrades
  class ComponentGrade < Treetop::Runtime::SyntaxNode
    def component
      return nil if elements.nil?
      return elements.select {|node|
        node.is_a? Component
      }.first
    end

    def grade
      return nil if elements.nil?
      return elements.select {|node|
        node.is_a? Grade
      }.first
    end

    def inspect
      "#{component.inspect}: #{grade.inspect}"
    end
  end

  class Component < Treetop::Runtime::SyntaxNode
    def inspect
      text_value
    end
  end

  class Grade < Treetop::Runtime::SyntaxNode
    def numerator
      return nil if elements.nil?
      candidate = elements.first
      return nil unless candidate.is_a? Numeric
      return candidate
    end

    def denominator
      return nil if elements.nil?
      return nil unless elements.size >= 2
      candidate = elements[1]
      return nil if candidate.nil?
      candidate = candidate.elements
      return nil if candidate.nil?
      candidate = candidate.select {|node|
        node.is_a? Numeric
      }.first
      return nil if candidate.nil?
      return candidate
    end

    def inspect
      n = numerator
      d = denominator
      result = ""
      result += n.to_f.to_s unless n.nil?
      result += " / #{d.to_f.to_s}" unless d.nil?
      return result
    end
  end

  class Numeric < Treetop::Runtime::SyntaxNode
    def to_f
      text_value.to_f
    end
  end
end
