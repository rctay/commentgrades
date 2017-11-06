require 'commentgrades'

grader = CommentGrades::Grader.new
grader << [:style, 5, {:is_negative => true}]
grader << [:design, 5]
grader << [:correctness, 20]
grader.main(ARGV) do |arg|
  match = /.*-ex01-student_([^.]*)/.match(arg)
  { :filename => arg, :student => match[1] }
end
