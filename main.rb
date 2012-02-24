require 'commentgrades'

grader = CommentGrades::Grader.new
grader << [:style, 5, {:is_negative => true}]
grader << [:design, 5, {:is_negative => true}]
grader << [:correctness, 20]
grader.main(ARGV) do |arg| {
  :filename => File.join(arg, 'birthday.c'),
  :student => arg
} end
