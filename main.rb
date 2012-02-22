base_path = File.expand_path(File.dirname(__FILE__))

require File.join(base_path, 'parser.rb')

filename = ARGV[0]
parser = CommentGradesParser.new
parser << { :style => 5 }
parser << { :design => 5 }
parser << { :correctness => 20 }
p parser.components
parser.parse_file(filename)
parser.walk_component_grades
