base_path = File.expand_path(File.dirname(__FILE__))

require File.join(base_path, 'grader.rb')

filename = ARGV[0]
grader = Grader.new
grader << [:style, 5, {:is_negative => true}]
grader << [:design, 5, {:is_negative => true}]
grader << [:correctness, 20]
grader.parse_file(filename)
p grader
