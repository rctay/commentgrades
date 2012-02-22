base_path = File.expand_path(File.dirname(__FILE__))

require File.join(base_path, 'parser.rb')

filename = ARGV[0]
parser = CommentGradesParser.new
parser.parse_file(filename)
parser.walk_component_grades
