require 'mustache'

module CommentGrades
  module Render
    class Default < Mustache
      self.template = \
"""report for {{student}}:{{prep_components}}
{{#components}}
{{name}}: {{grade}}/{{outof}}
{{/components}}
{{#final_adjustment}}
final {{adjustment}}
{{/final_adjustment}}
{{final_justified}}: {{grade}}/{{outof}}

"""

      @width = 0
      def prep_components
        c = self[:components]
        @width = c.map {|d|
          d[:name] = d[:name].to_s
          d[:name].size
        }.max + 1
        c.each do |d|
          d[:name] = d[:name].ljust(@width)
        end
        # don't render anything when called
        ''
      end

      def final_justified
        "final".ljust @width
      end
    end
  end
end
