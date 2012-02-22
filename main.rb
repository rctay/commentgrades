base_path = File.expand_path(File.dirname(__FILE__))

require File.join(base_path, 'parser.rb')

filename = ARGV[0]
open(filename, 'r') do |f|
  parser = CommentGradesParser.new
  parser.parse(f.read)
  parser.walk_component_grades
end
