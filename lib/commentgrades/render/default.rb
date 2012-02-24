require 'mustache'

module CommentGrades
  module Render
    class Default < Mustache
      self.template = \
"""report for {{student}}:
{{#components}}
{{name}}: {{grade}}/{{outof}}
{{/components}}
{{#final_adjustment}}
final {{adjustment}}
{{/final_adjustment}}
final: {{grade}}/{{outof}}

"""
    end
  end
end
