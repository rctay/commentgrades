module CommentGrades
  module Helpers
    def elements_is_a?(kls)
      return nil if elements.nil?
      return elements.select {|node|
        node.is_a? kls
      }
    end

    def first_is_a?(kls)
      all = elements_is_a?(kls)
      return nil if all.nil?
      return all.first
    end
  end

  class ComponentGrade < Treetop::Runtime::SyntaxNode
    include Helpers

    def component
      return first_is_a? Component
    end

    def grade
      return first_is_a? Grade
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
    include Helpers

    def numerator
      return first_is_a? Numeric
    end

    def denominator
      return nil if elements.nil?
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
