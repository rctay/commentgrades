Specify grades across a student's code submission, and tally them up.

# Dependencies

- [Treetop](https://github.com/nathansobo/treetop/): PEG for Ruby
- [Mustache](https://github.com/mustache/mustache/): console output reports are actually templates being rendered!

# Example

Step 0: install dependencies with `bundle install`.

Step 1: define the component breakdown of your marks (supported components: style, design, correctness):

```ruby
require 'commentgrades'

grader = CommentGrades::Grader.new
grader << [:style, 5, {:is_negative => true}]
grader << [:design, 5]
grader << [:correctness, 20]
grader.main(ARGV) do |arg|
  match = /.*-ex01-student_([^.]*)/.match(arg)
  { :filename => arg, :student => match[1] }
end
```

Step 2: add comments `/* M: ... */` to add/minus marks to the components:

```c
/* M: [M]arker's comments ..., style -1 */
int graded_function() {
    ...
    /* M: lgtm, 4/5 for design, ...more comments..., full correctness */
}
```

Much like how [Github has different keywords](https://help.github.com/articles/closing-issues-using-keywords/), you can say:
- `<component>: <grade>` or  `<component> = <grade>` (spaces are just for taste and don't matter)
- `## for <component>` or `## in <component>`
- `full <component>`

You can pack a couple of them within the same comment.

See the `componentgrade` rule in the [grammar](lib/commentgrades/parser/c_source.treetop) for all supported variations.

Step 3: profit:

```console    
$ ruby -Ilib example/class_1001-ex01.rb example/class_1001-ex01-student_Aida.c
report for Aida:
style       : 4.0/5
design      : 4.0/5
correctness : 20/20
final       : 28.0/30
```

You can output the format as CSV as well, run `--help` to see how. The reports are actually Mustache templates being rendered!
