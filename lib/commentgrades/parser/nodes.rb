module CommentGrades
  module Parser
    module Helpers
      def first_is_a?(kls, nodes=nil)
        nodes ||= elements
        return nil if nodes.nil?
        nodes.find {|node| node.is_a? kls}
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
    end

    class FullGrade < Grade
    end

    class NumericGrade < Grade
      include Helpers

      def numerator
        first_is_a? Numeric
      end

      def denominator
        return nil if elements.nil?
        candidate = elements[1]
        return first_is_a? Numeric, candidate.elements
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
end
