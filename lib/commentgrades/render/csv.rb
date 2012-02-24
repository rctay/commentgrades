require 'mustache'

module CommentGrades
  module Render
    class CSV < Mustache
      self.template = \
        "{{#first}}{{header}}\n{{/first}}" \
        "{{row}}\n"

      def header
        return nil if self[:first].nil?
        cols = []
        cols << "student"
        self[:components].each do |d|
          cols << "#{d[:name]} /#{d[:outof]}"
        end
        cols << "final adjustment"
        cols << "final /#{self[:outof]}"
        return cols.join(",")
      end

      def row
        cols = []
        cols << self[:student]
        self[:components].each do |d|
          cols << d[:grade]
        end
        adjustment = 0
        adjustment = self[:final_adjustment][:adjustment] \
          if self[:final_adjustment]
        cols << adjustment
        cols << self[:grade]
        return cols.join(",")
      end
    end
  end
end
