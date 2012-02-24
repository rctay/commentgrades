require 'commentgrades'

filename = ARGV[0]
grader = CommentGrades::Grader.new
grader << [:style, 5, {:is_negative => true}]
grader << [:design, 5, {:is_negative => true}]
grader << [:correctness, 20]
grader.parse_file(filename)
p grader
