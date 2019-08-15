# Layout

## Layout/AccessModifierIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Bare access modifiers (those not applying to specific methods) should be
indented as deep as method definitions, or as deep as the class/module
keyword, depending on configuration.

### Examples

#### EnforcedStyle: indent (default)

```ruby
# bad
class Plumbus
private
  def smooth; end
end

# good
class Plumbus
  private
  def smooth; end
end
```
#### EnforcedStyle: outdent

```ruby
# bad
class Plumbus
  private
  def smooth; end
end

# good
class Plumbus
private
  def smooth; end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `indent` | `outdent`, `indent`
IndentationWidth | `<none>` | Integer

### References

* [https://rubystyle.guide#indent-public-private-protected](https://rubystyle.guide#indent-public-private-protected)

## Layout/AlignArguments

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.68 | -

Here we check if the arguments on a multi-line method
definition are aligned.

### Examples

#### EnforcedStyle: with_first_argument (default)

```ruby
# good

foo :bar,
    :baz

foo(
  :bar,
  :baz
)

# bad

foo :bar,
  :baz

foo(
  :bar,
    :baz
)
```
#### EnforcedStyle: with_fixed_indentation

```ruby
# good

foo :bar,
  :baz

# bad

foo :bar,
    :baz
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `with_first_argument` | `with_first_argument`, `with_fixed_indentation`
IndentationWidth | `<none>` | Integer

### References

* [https://rubystyle.guide#no-double-indent](https://rubystyle.guide#no-double-indent)

## Layout/AlignArray

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Here we check if the elements of a multi-line array literal are
aligned.

### Examples

```ruby
# bad
a = [1, 2, 3,
  4, 5, 6]
array = ['run',
     'forrest',
     'run']

# good
a = [1, 2, 3,
     4, 5, 6]
a = ['run',
     'forrest',
     'run']
```

### References

* [https://rubystyle.guide#align-multiline-arrays](https://rubystyle.guide#align-multiline-arrays)

## Layout/AlignHash

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Check that the keys, separators, and values of a multi-line hash
literal are aligned according to configuration. The configuration
options are:

  - key (left align keys, one space before hash rockets and values)
  - separator (align hash rockets and colons, right align keys)
  - table (left align keys, hash rockets, and values)

The treatment of hashes passed as the last argument to a method call
can also be configured. The options are:

  - always_inspect
  - always_ignore
  - ignore_implicit (without curly braces)

Alternatively you can specify multiple allowed styles. That's done by
passing a list of styles to EnforcedStyles.

### Examples

#### EnforcedHashRocketStyle: key (default)

```ruby
# bad
{
  :foo => bar,
   :ba => baz
}
{
  :foo => bar,
  :ba  => baz
}

# good
{
  :foo => bar,
  :ba => baz
}
```
#### EnforcedHashRocketStyle: separator

```ruby
# bad
{
  :foo => bar,
  :ba => baz
}
{
  :foo => bar,
  :ba  => baz
}

# good
{
  :foo => bar,
   :ba => baz
}
```
#### EnforcedHashRocketStyle: table

```ruby
# bad
{
  :foo => bar,
   :ba => baz
}

# good
{
  :foo => bar,
  :ba  => baz
}
```
#### EnforcedColonStyle: key (default)

```ruby
# bad
{
  foo: bar,
   ba: baz
}
{
  foo: bar,
  ba:  baz
}

# good
{
  foo: bar,
  ba: baz
}
```
#### EnforcedColonStyle: separator

```ruby
# bad
{
  foo: bar,
  ba: baz
}

# good
{
  foo: bar,
   ba: baz
}
```
#### EnforcedColonStyle: table

```ruby
# bad
{
  foo: bar,
  ba: baz
}

# good
{
  foo: bar,
  ba:  baz
}
```
#### EnforcedLastArgumentHashStyle: always_inspect (default)

```ruby
# Inspect both implicit and explicit hashes.

# bad
do_something(foo: 1,
  bar: 2)

# bad
do_something({foo: 1,
  bar: 2})

# good
do_something(foo: 1,
             bar: 2)

# good
do_something(
  foo: 1,
  bar: 2
)

# good
do_something({foo: 1,
              bar: 2})

# good
do_something({
  foo: 1,
  bar: 2
})
```
#### EnforcedLastArgumentHashStyle: always_ignore

```ruby
# Ignore both implicit and explicit hashes.

# good
do_something(foo: 1,
  bar: 2)

# good
do_something({foo: 1,
  bar: 2})
```
#### EnforcedLastArgumentHashStyle: ignore_implicit

```ruby
# Ignore only implicit hashes.

# bad
do_something({foo: 1,
  bar: 2})

# good
do_something(foo: 1,
  bar: 2)
```
#### EnforcedLastArgumentHashStyle: ignore_explicit

```ruby
# Ignore only explicit hashes.

# bad
do_something(foo: 1,
  bar: 2)

# good
do_something({foo: 1,
  bar: 2})
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedHashRocketStyle | `key` | `key`, `separator`, `table`
EnforcedColonStyle | `key` | `key`, `separator`, `table`
EnforcedLastArgumentHashStyle | `always_inspect` | `always_inspect`, `always_ignore`, `ignore_implicit`, `ignore_explicit`

## Layout/AlignParameters

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.68

Here we check if the parameters on a multi-line method call or
definition are aligned.

To set the alignment of the first argument, use the cop
FirstParameterIndentation.

### Examples

#### EnforcedStyle: with_first_parameter (default)

```ruby
# good

def foo(bar,
        baz)
  123
end

def foo(
  bar,
  baz
)
  123
end

# bad

def foo(bar,
     baz)
  123
end

# bad

def foo(
  bar,
     baz)
  123
end
```
#### EnforcedStyle: with_fixed_indentation

```ruby
# good

def foo(bar,
  baz)
  123
end

def foo(
  bar,
  baz
)
  123
end

# bad

def foo(bar,
        baz)
  123
end

# bad

def foo(
  bar,
     baz)
  123
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `with_first_parameter` | `with_first_parameter`, `with_fixed_indentation`
IndentationWidth | `<none>` | Integer

### References

* [https://rubystyle.guide#no-double-indent](https://rubystyle.guide#no-double-indent)

## Layout/BlockAlignment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.53 | -

This cop checks whether the end keywords are aligned properly for do
end blocks.

Three modes are supported through the `EnforcedStyleAlignWith`
configuration parameter:

`start_of_block` : the `end` shall be aligned with the
start of the line where the `do` appeared.

`start_of_line` : the `end` shall be aligned with the
start of the line where the expression started.

`either` (which is the default) : the `end` is allowed to be in either
location. The autofixer will default to `start_of_line`.

### Examples

#### EnforcedStyleAlignWith: either (default)

```ruby
# bad

foo.bar
   .each do
     baz
       end

begin
  baz
  end

# good

variable = lambda do |i|
  i
end

variable = begin
  baz
end
```
#### EnforcedStyleAlignWith: start_of_block

```ruby
# bad

foo.bar
   .each do
     baz
       end

x =
  begin
    baz
end

# good

foo.bar
  .each do
    baz
  end

x =
  begin
    baz
  end
```
#### EnforcedStyleAlignWith: start_of_line

```ruby
# bad

foo.bar
   .each do
     baz
       end

x = begin
      baz
    end

# good

foo.bar
  .each do
     baz
end

x = begin
  baz
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyleAlignWith | `either` | `either`, `start_of_block`, `start_of_line`

## Layout/BlockEndNewline

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks whether the end statement of a do..end block
is on its own line.

### Examples

```ruby
# bad
blah do |i|
  foo(i) end

# good
blah do |i|
  foo(i)
end

# bad
blah { |i|
  foo(i) }

# good
blah { |i|
  foo(i)
}
```

## Layout/CaseIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks how the *when*s of a *case* expression
are indented in relation to its *case* or *end* keyword.

It will register a separate offense for each misaligned *when*.

### Examples

```ruby
# If Layout/EndAlignment is set to keyword style (default)
# *case* and *end* should always be aligned to same depth,
# and therefore *when* should always be aligned to both -
# regardless of configuration.

# bad for all styles
case n
  when 0
    x * 2
  else
    y / 3
end

# good for all styles
case n
when 0
  x * 2
else
  y / 3
end
```
#### EnforcedStyle: case (default)

```ruby
# if EndAlignment is set to other style such as
# start_of_line (as shown below), then *when* alignment
# configuration does have an effect.

# bad
a = case n
when 0
  x * 2
else
  y / 3
end

# good
a = case n
    when 0
      x * 2
    else
      y / 3
end
```
#### EnforcedStyle: end

```ruby
# bad
a = case n
    when 0
      x * 2
    else
      y / 3
end

# good
a = case n
when 0
  x * 2
else
  y / 3
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `case` | `case`, `end`
IndentOneStep | `false` | Boolean
IndentationWidth | `<none>` | Integer

### References

* [https://rubystyle.guide#indent-when-to-case](https://rubystyle.guide#indent-when-to-case)

## Layout/ClassStructure

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.52 | -

Checks if the code style follows the ExpectedOrder configuration:

`Categories` allows us to map macro names into a category.

Consider an example of code style that covers the following order:
- Module inclusion (include, prepend, extend)
- Constants
- Associations (has_one, has_many)
- Public attribute macros (attr_accessor, attr_writer, attr_reader)
- Other macros (validates, validate)
- Public class methods
- Initializer
- Public instance methods
- Protected attribute macros (attr_accessor, attr_writer, attr_reader)
- Protected instance methods
- Private attribute macros (attr_accessor, attr_writer, attr_reader)
- Private instance methods

You can configure the following order:

```yaml
 Layout/ClassStructure:
   ExpectedOrder:
     - module_inclusion
     - constants
     - association
     - public_attribute_macros
     - public_delegate
     - macros
     - public_class_methods
     - initializer
     - public_methods
     - protected_attribute_macros
     - protected_methods
     - private_attribute_macros
     - private_delegate
     - private_methods
```

Instead of putting all literals in the expected order, is also
possible to group categories of macros. Visibility levels are handled
automatically.

```yaml
 Layout/ClassStructure:
   Categories:
     association:
       - has_many
       - has_one
     attribute_macros:
       - attr_accessor
       - attr_reader
       - attr_writer
     macros:
       - validates
       - validate
     module_inclusion:
       - include
       - prepend
       - extend
```

### Examples

```ruby
# bad
# Expect extend be before constant
class Person < ApplicationRecord
  has_many :orders
  ANSWER = 42

  extend SomeModule
  include AnotherModule
end

# good
class Person
  # extend and include go first
  extend SomeModule
  include AnotherModule

  # inner classes
  CustomError = Class.new(StandardError)

  # constants are next
  SOME_CONSTANT = 20

  # afterwards we have public attribute macros
  attr_reader :name

  # followed by other macros (if any)
  validates :name

  # then we have public delegate macros
  delegate :to_s, to: :name

  # public class methods are next in line
  def self.some_method
  end

  # initialization goes between class methods and instance methods
  def initialize
  end

  # followed by other public instance methods
  def some_method
  end

  # protected attribute macros and methods go next
  protected

  attr_reader :protected_name

  def some_protected_method
  end

  # private attribute macros, delegate macros and methods
  # are grouped near the end
  private

  attr_reader :private_name

  delegate :some_private_delegate, to: :name

  def some_private_method
  end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Categories | `{"module_inclusion"=>["include", "prepend", "extend"]}` | 
ExpectedOrder | `module_inclusion`, `constants`, `public_class_methods`, `initializer`, `public_methods`, `protected_methods`, `private_methods` | Array

### References

* [https://rubystyle.guide#consistent-classes](https://rubystyle.guide#consistent-classes)

## Layout/ClosingHeredocIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.57 | -

Checks the indentation of here document closings.

### Examples

```ruby
# bad
class Foo
  def bar
    <<~SQL
      'Hi'
  SQL
  end
end

# good
class Foo
  def bar
    <<~SQL
      'Hi'
    SQL
  end
end

# bad

# heredoc contents is before closing heredoc.
foo arg,
    <<~EOS
  Hi
    EOS

# good
foo arg,
    <<~EOS
  Hi
EOS

# good
foo arg,
    <<~EOS
      Hi
    EOS
```

## Layout/ClosingParenthesisIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks the indentation of hanging closing parentheses in
method calls, method definitions, and grouped expressions. A hanging
closing parenthesis means `)` preceded by a line break.

### Examples

```ruby
# bad
some_method(
  a,
  b
  )

some_method(
  a, b
  )

some_method(a, b, c
  )

some_method(a,
            b,
            c
  )

some_method(a,
  x: 1,
  y: 2
  )

# Scenario 1: When First Parameter Is On Its Own Line

# good: when first param is on a new line, right paren is *always*
#       outdented by IndentationWidth
some_method(
  a,
  b
)

# good
some_method(
  a, b
)

# Scenario 2: When First Parameter Is On The Same Line

# good: when all other params are also on the same line, outdent
#       right paren by IndentationWidth
some_method(a, b, c
           )

# good: when all other params are on multiple lines, but are lined
#       up, align right paren with left paren
some_method(a,
            b,
            c
           )

# good: when other params are not lined up on multiple lines, outdent
#       right paren by IndentationWidth
some_method(a,
  x: 1,
  y: 2
)
```

## Layout/CommentIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks the indentation of comments.

### Examples

```ruby
# bad
  # comment here
def method_name
end

  # comment here
a = 'hello'

# yet another comment
  if true
    true
  end

# good
# comment here
def method_name
end

# comment here
a = 'hello'

# yet another comment
if true
  true
end
```

## Layout/ConditionPosition

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | 0.53 | -

This cop checks for conditions that are not on the same line as
if/while/until.

### Examples

```ruby
# bad

if
  some_condition
  do_something
end
```
```ruby
# good

if some_condition
  do_something
end
```

### References

* [https://rubystyle.guide#same-line-condition](https://rubystyle.guide#same-line-condition)

## Layout/DefEndAlignment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.53 | -

This cop checks whether the end keywords of method definitions are
aligned properly.

Two modes are supported through the EnforcedStyleAlignWith configuration
parameter. If it's set to `start_of_line` (which is the default), the
`end` shall be aligned with the start of the line where the `def`
keyword is. If it's set to `def`, the `end` shall be aligned with the
`def` keyword.

### Examples

#### EnforcedStyleAlignWith: start_of_line (default)

```ruby
# bad

private def foo
            end

# good

private def foo
end
```
#### EnforcedStyleAlignWith: def

```ruby
# bad

private def foo
            end

# good

private def foo
        end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyleAlignWith | `start_of_line` | `start_of_line`, `def`
AutoCorrect | `false` | Boolean
Severity | `warning` | String

## Layout/DotPosition

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks the . position in multi-line method calls.

### Examples

#### EnforcedStyle: leading (default)

```ruby
# bad
something.
  method

# good
something
  .method
```
#### EnforcedStyle: trailing

```ruby
# bad
something
  .method

# good
something.
  method
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `leading` | `leading`, `trailing`

### References

* [https://rubystyle.guide#consistent-multi-line-chains](https://rubystyle.guide#consistent-multi-line-chains)

## Layout/ElseAlignment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks the alignment of else keywords. Normally they should
be aligned with an if/unless/while/until/begin/def keyword, but there
are special cases when they should follow the same rules as the
alignment of end.

### Examples

```ruby
# bad
if something
  code
 else
  code
end

# bad
if something
  code
 elsif something
  code
end

# good
if something
  code
else
  code
end
```

## Layout/EmptyComment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.53 | -

This cop checks empty comment.

### Examples

```ruby
# bad

#
class Foo
end

# good

#
# Description of `Foo` class.
#
class Foo
end
```
#### AllowBorderComment: true (default)

```ruby
# good

def foo
end

#################

def bar
end
```
#### AllowBorderComment: false

```ruby
# bad

def foo
end

#################

def bar
end
```
#### AllowMarginComment: true (default)

```ruby
# good

#
# Description of `Foo` class.
#
class Foo
end
```
#### AllowMarginComment: false

```ruby
# bad

#
# Description of `Foo` class.
#
class Foo
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
AllowBorderComment | `true` | Boolean
AllowMarginComment | `true` | Boolean

## Layout/EmptyLineAfterGuardClause

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.56 | 0.59

This cop enforces empty line after guard clause

### Examples

```ruby
# bad
def foo
  return if need_return?
  bar
end

# good
def foo
  return if need_return?

  bar
end

# good
def foo
  return if something?
  return if something_different?

  bar
end

# also good
def foo
  if something?
    do_something
    return if need_return?
  end
end
```

## Layout/EmptyLineAfterMagicComment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for a newline after the final magic comment.

### Examples

```ruby
# good
# frozen_string_literal: true

# Some documentation for Person
class Person
  # Some code
end

# bad
# frozen_string_literal: true
# Some documentation for Person
class Person
  # Some code
end
```

### References

* [https://rubystyle.guide#separate-magic-comments-from-code](https://rubystyle.guide#separate-magic-comments-from-code)

## Layout/EmptyLineBetweenDefs

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks whether method definitions are
separated by one empty line.

`NumberOfEmptyLines` can be an integer (default is 1) or
an array (e.g. [1, 2]) to specify a minimum and maximum
number of empty lines permitted.

`AllowAdjacentOneLineDefs` configures whether adjacent
one-line method definitions are considered an offense.

### Examples

```ruby
# bad
def a
end
def b
end
```
```ruby
# good
def a
end

def b
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
AllowAdjacentOneLineDefs | `false` | Boolean
NumberOfEmptyLines | `1` | Integer

### References

* [https://rubystyle.guide#empty-lines-between-methods](https://rubystyle.guide#empty-lines-between-methods)

## Layout/EmptyLines

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for two or more consecutive blank lines.

### Examples

```ruby
# bad - It has two empty lines.
some_method
# one empty line
# two empty lines
some_method

# good
some_method
# one empty line
some_method
```

### References

* [https://rubystyle.guide#two-or-more-empty-lines](https://rubystyle.guide#two-or-more-empty-lines)

## Layout/EmptyLinesAroundAccessModifier

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Access modifiers should be surrounded by blank lines.

### Examples

#### EnforcedStyle: around (default)

```ruby
# bad
class Foo
  def bar; end
  private
  def baz; end
end

# good
class Foo
  def bar; end

  private

  def baz; end
end
```
#### EnforcedStyle: only_before

```ruby
# bad
class Foo
  def bar; end
  private
  def baz; end
end

# good
class Foo
  def bar; end

  private
  def baz; end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `around` | `around`, `only_before`

### References

* [https://rubystyle.guide#empty-lines-around-access-modifier](https://rubystyle.guide#empty-lines-around-access-modifier)
* [https://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html#follow-the-coding-conventions](https://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html#follow-the-coding-conventions)

## Layout/EmptyLinesAroundArguments

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.52 | -

This cop checks if empty lines exist around the arguments
of a method invocation.

### Examples

```ruby
# bad
do_something(
  foo

)

process(bar,

        baz: qux,
        thud: fred)

some_method(

  [1,2,3],
  x: y
)

# good
do_something(
  foo
)

process(bar,
        baz: qux,
        thud: fred)

some_method(
  [1,2,3],
  x: y
)
```

## Layout/EmptyLinesAroundBeginBody

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks if empty lines exist around the bodies of begin-end
blocks.

### Examples

```ruby
# good

begin
  # ...
end

# bad

begin

  # ...

end
```

### References

* [https://rubystyle.guide#empty-lines-around-bodies](https://rubystyle.guide#empty-lines-around-bodies)

## Layout/EmptyLinesAroundBlockBody

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks if empty lines around the bodies of blocks match
the configuration.

### Examples

#### EnforcedStyle: empty_lines

```ruby
# good

foo do |bar|

  # ...

end
```
#### EnforcedStyle: no_empty_lines (default)

```ruby
# good

foo do |bar|
  # ...
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `no_empty_lines` | `empty_lines`, `no_empty_lines`

### References

* [https://rubystyle.guide#empty-lines-around-bodies](https://rubystyle.guide#empty-lines-around-bodies)

## Layout/EmptyLinesAroundClassBody

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.53

This cop checks if empty lines around the bodies of classes match
the configuration.

### Examples

#### EnforcedStyle: empty_lines

```ruby
# good

class Foo

  def bar
    # ...
  end

end
```
#### EnforcedStyle: empty_lines_except_namespace

```ruby
# good

class Foo
  class Bar

    # ...

  end
end
```
#### EnforcedStyle: empty_lines_special

```ruby
# good
class Foo

  def bar; end

end
```
#### Enforcedstyle: beginning_only

```ruby
# good

class Foo

  def bar
    # ...
  end
end
```
#### Enforcedstyle: ending_only

```ruby
# good

class Foo
  def bar
    # ...
  end

end
```
#### EnforcedStyle: no_empty_lines (default)

```ruby
# good

class Foo
  def bar
    # ...
  end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `no_empty_lines` | `empty_lines`, `empty_lines_except_namespace`, `empty_lines_special`, `no_empty_lines`, `beginning_only`, `ending_only`

### References

* [https://rubystyle.guide#empty-lines-around-bodies](https://rubystyle.guide#empty-lines-around-bodies)

## Layout/EmptyLinesAroundExceptionHandlingKeywords

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks if empty lines exist around the bodies of `begin`
sections. This cop doesn't check empty lines at `begin` body
beginning/end and around method definition body.
`Style/EmptyLinesAroundBeginBody` or `Style/EmptyLinesAroundMethodBody`
can be used for this purpose.

### Examples

```ruby
# good

begin
  do_something
rescue
  do_something2
else
  do_something3
ensure
  do_something4
end

# good

def foo
  do_something
rescue
  do_something2
end

# bad

begin
  do_something

rescue

  do_something2

else

  do_something3

ensure

  do_something4
end

# bad

def foo
  do_something

rescue

  do_something2
end
```

### References

* [https://rubystyle.guide#empty-lines-around-bodies](https://rubystyle.guide#empty-lines-around-bodies)

## Layout/EmptyLinesAroundMethodBody

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks if empty lines exist around the bodies of methods.

### Examples

```ruby
# good

def foo
  # ...
end

# bad

def bar

  # ...

end
```

### References

* [https://rubystyle.guide#empty-lines-around-bodies](https://rubystyle.guide#empty-lines-around-bodies)

## Layout/EmptyLinesAroundModuleBody

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks if empty lines around the bodies of modules match
the configuration.

### Examples

#### EnforcedStyle: empty_lines

```ruby
# good

module Foo

  def bar
    # ...
  end

end
```
#### EnforcedStyle: empty_lines_except_namespace

```ruby
# good

module Foo
  module Bar

    # ...

  end
end
```
#### EnforcedStyle: empty_lines_special

```ruby
# good
module Foo

  def bar; end

end
```
#### EnforcedStyle: no_empty_lines (default)

```ruby
# good

module Foo
  def bar
    # ...
  end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `no_empty_lines` | `empty_lines`, `empty_lines_except_namespace`, `empty_lines_special`, `no_empty_lines`

### References

* [https://rubystyle.guide#empty-lines-around-bodies](https://rubystyle.guide#empty-lines-around-bodies)

## Layout/EndAlignment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.53 | -

This cop checks whether the end keywords are aligned properly.

Three modes are supported through the `EnforcedStyleAlignWith`
configuration parameter:

If it's set to `keyword` (which is the default), the `end`
shall be aligned with the start of the keyword (if, class, etc.).

If it's set to `variable` the `end` shall be aligned with the
left-hand-side of the variable assignment, if there is one.

If it's set to `start_of_line`, the `end` shall be aligned with the
start of the line where the matching keyword appears.

### Examples

#### EnforcedStyleAlignWith: keyword (default)

```ruby
# bad

variable = if true
    end

# good

variable = if true
           end

variable =
  if true
  end
```
#### EnforcedStyleAlignWith: variable

```ruby
# bad

variable = if true
    end

# good

variable = if true
end

variable =
  if true
  end
```
#### EnforcedStyleAlignWith: start_of_line

```ruby
# bad

variable = if true
    end

puts(if true
     end)

# good

variable = if true
end

puts(if true
end)

variable =
  if true
  end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyleAlignWith | `keyword` | `keyword`, `variable`, `start_of_line`
AutoCorrect | `false` | Boolean
Severity | `warning` | String

## Layout/EndOfLine

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | No | 0.49 | -

This cop checks for Windows-style line endings in the source code.

### Examples

#### EnforcedStyle: native (default)

```ruby
# The `native` style means that CR+LF (Carriage Return + Line Feed) is
# enforced on Windows, and LF is enforced on other platforms.

# bad
puts 'Hello' # Return character is LF on Windows.
puts 'Hello' # Return character is CR+LF on other than Windows.

# good
puts 'Hello' # Return character is CR+LF on Windows.
puts 'Hello' # Return character is LF on other than Windows.
```
#### EnforcedStyle: lf

```ruby
# The `lf` style means that LF (Line Feed) is enforced on
# all platforms.

# bad
puts 'Hello' # Return character is CR+LF on all platfoms.

# good
puts 'Hello' # Return character is LF on all platfoms.
```
#### EnforcedStyle: crlf

```ruby
# The `crlf` style means that CR+LF (Carriage Return + Line Feed) is
# enforced on all platforms.

# bad
puts 'Hello' # Return character is LF on all platfoms.

# good
puts 'Hello' # Return character is CR+LF on all platfoms.
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `native` | `native`, `lf`, `crlf`

### References

* [https://rubystyle.guide#crlf](https://rubystyle.guide#crlf)

## Layout/ExtraSpacing

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for extra/unnecessary whitespace.

### Examples

```ruby
# good if AllowForAlignment is true
name      = "RuboCop"
# Some comment and an empty line

website  += "/rubocop-hq/rubocop" unless cond
puts        "rubocop"          if     debug

# bad for any configuration
set_app("RuboCop")
website  = "https://github.com/rubocop-hq/rubocop"

# good only if AllowBeforeTrailingComments is true
object.method(arg)  # this is a comment

# good even if AllowBeforeTrailingComments is false or not set
object.method(arg) # this is a comment

# good with either AllowBeforeTrailingComments or AllowForAlignment
object.method(arg)         # this is a comment
another_object.method(arg) # this is another comment
some_object.method(arg)    # this is some comment
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
AllowForAlignment | `true` | Boolean
AllowBeforeTrailingComments | `false` | Boolean
ForceEqualSignAlignment | `false` | Boolean

## Layout/FirstArrayElementLineBreak

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.49 | -

This cop checks for a line break before the first element in a
multi-line array.

### Examples

```ruby
# bad
[ :a,
  :b]

# good
[
  :a,
  :b]
```

## Layout/FirstHashElementLineBreak

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.49 | -

This cop checks for a line break before the first element in a
multi-line hash.

### Examples

```ruby
# bad
{ a: 1,
  b: 2}

# good
{
  a: 1,
  b: 2 }
```

## Layout/FirstMethodArgumentLineBreak

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.49 | -

This cop checks for a line break before the first argument in a
multi-line method call.

### Examples

```ruby
# bad
method(foo, bar,
  baz)

# good
method(
  foo, bar,
  baz)

# ignored
method foo, bar,
  baz
```

## Layout/FirstMethodParameterLineBreak

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.49 | -

This cop checks for a line break before the first parameter in a
multi-line method parameter definition.

### Examples

```ruby
# bad
def method(foo, bar,
    baz)
  do_something
end

# good
def method(
    foo, bar,
    baz)
  do_something
end

# ignored
def method foo,
    bar
  do_something
end
```

## Layout/HeredocArgumentClosingParenthesis

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.68 | -

This cop checks for the placement of the closing parenthesis
in a method call that passes a HEREDOC string as an argument.
It should be placed at the end of the line containing the
opening HEREDOC tag.

### Examples

```ruby
# bad

   foo(<<-SQL
     bar
   SQL
   )

   foo(<<-SQL, 123, <<-NOSQL,
     bar
   SQL
     baz
   NOSQL
   )

   foo(
     bar(<<-SQL
       baz
     SQL
     ),
     123,
   )

# good

   foo(<<-SQL)
     bar
   SQL

   foo(<<-SQL, 123, <<-NOSQL)
     bar
   SQL
     baz
   NOSQL

   foo(
     bar(<<-SQL),
       baz
     SQL
     123,
   )
```

### References

* [https://rubystyle.guide#heredoc-argument-closing-parentheses](https://rubystyle.guide#heredoc-argument-closing-parentheses)

## Layout/IndentAssignment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks the indentation of the first line of the
right-hand-side of a multi-line assignment.

The indentation of the remaining lines can be corrected with
other cops such as `IndentationConsistency` and `EndAlignment`.

### Examples

```ruby
# bad
value =
if foo
  'bar'
end

# good
value =
  if foo
    'bar'
  end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
IndentationWidth | `<none>` | Integer

## Layout/IndentFirstArgument

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.68 | -

This cop checks the indentation of the first argument in a method call.
Arguments after the first one are checked by Layout/AlignArguments,
not by this cop.

For indenting the first parameter of method *definitions*, check out
Layout/IndentFirstParameter.

### Examples

```ruby
# bad
some_method(
first_param,
second_param)

foo = some_method(
first_param,
second_param)

foo = some_method(nested_call(
nested_first_param),
second_param)

foo = some_method(
nested_call(
nested_first_param),
second_param)

some_method nested_call(
nested_first_param),
second_param
```
#### EnforcedStyle: consistent

```ruby
# The first argument should always be indented one step more than the
# preceding line.

# good
some_method(
  first_param,
second_param)

foo = some_method(
  first_param,
second_param)

foo = some_method(nested_call(
  nested_first_param),
second_param)

foo = some_method(
  nested_call(
    nested_first_param),
second_param)

some_method nested_call(
  nested_first_param),
second_param
```
#### EnforcedStyle: consistent_relative_to_receiver

```ruby
# The first argument should always be indented one level relative to
# the parent that is receiving the argument

# good
some_method(
  first_param,
second_param)

foo = some_method(
        first_param,
second_param)

foo = some_method(nested_call(
                    nested_first_param),
second_param)

foo = some_method(
        nested_call(
          nested_first_param),
second_param)

some_method nested_call(
              nested_first_param),
second_params
```
#### EnforcedStyle: special_for_inner_method_call

```ruby
# The first argument should normally be indented one step more than
# the preceding line, but if it's a argument for a method call that
# is itself a argument in a method call, then the inner argument
# should be indented relative to the inner method.

# good
some_method(
  first_param,
second_param)

foo = some_method(
  first_param,
second_param)

foo = some_method(nested_call(
                    nested_first_param),
second_param)

foo = some_method(
  nested_call(
    nested_first_param),
second_param)

some_method nested_call(
              nested_first_param),
second_param
```
#### EnforcedStyle: special_for_inner_method_call_in_parentheses (default)

```ruby
# Same as `special_for_inner_method_call` except that the special rule
# only applies if the outer method call encloses its arguments in
# parentheses.

# good
some_method(
  first_param,
second_param)

foo = some_method(
  first_param,
second_param)

foo = some_method(nested_call(
                    nested_first_param),
second_param)

foo = some_method(
  nested_call(
    nested_first_param),
second_param)

some_method nested_call(
  nested_first_param),
second_param
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `special_for_inner_method_call_in_parentheses` | `consistent`, `consistent_relative_to_receiver`, `special_for_inner_method_call`, `special_for_inner_method_call_in_parentheses`
IndentationWidth | `<none>` | Integer

## Layout/IndentFirstArrayElement

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.68 | -

This cop checks the indentation of the first element in an array literal
where the opening bracket and the first element are on separate lines.
The other elements' indentations are handled by the AlignArray cop.

By default, array literals that are arguments in a method call with
parentheses, and where the opening square bracket of the array is on the
same line as the opening parenthesis of the method call, shall have
their first element indented one step (two spaces) more than the
position inside the opening parenthesis.

Other array literals shall have their first element indented one step
more than the start of the line where the opening square bracket is.

This default style is called 'special_inside_parentheses'. Alternative
styles are 'consistent' and 'align_brackets'. Here are examples:

### Examples

#### EnforcedStyle: special_inside_parentheses (default)

```ruby
# The `special_inside_parentheses` style enforces that the first
# element in an array literal where the opening bracket and first
# element are on seprate lines is indented one step (two spaces) more
# than the position inside the opening parenthesis.

#bad
array = [
  :value
]
and_in_a_method_call([
  :no_difference
                     ])

#good
array = [
  :value
]
but_in_a_method_call([
                       :its_like_this
                     ])
```
#### EnforcedStyle: consistent

```ruby
# The `consistent` style enforces that the first element in an array
# literal where the opening bracket and the first element are on
# seprate lines is indented the same as an array literal which is not
# defined inside a method call.

#bad
# consistent
array = [
  :value
]
but_in_a_method_call([
                       :its_like_this
])

#good
array = [
  :value
]
and_in_a_method_call([
  :no_difference
])
```
#### EnforcedStyle: align_brackets

```ruby
# The `align_brackets` style enforces that the opening and closing
# brackets are indented to the same position.

#bad
# align_brackets
and_now_for_something = [
                          :completely_different
]

#good
# align_brackets
and_now_for_something = [
                          :completely_different
                        ]
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `special_inside_parentheses` | `special_inside_parentheses`, `consistent`, `align_brackets`
IndentationWidth | `<none>` | Integer

## Layout/IndentFirstHashElement

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.68 | -

This cop checks the indentation of the first key in a hash literal
where the opening brace and the first key are on separate lines. The
other keys' indentations are handled by the AlignHash cop.

By default, Hash literals that are arguments in a method call with
parentheses, and where the opening curly brace of the hash is on the
same line as the opening parenthesis of the method call, shall have
their first key indented one step (two spaces) more than the position
inside the opening parenthesis.

Other hash literals shall have their first key indented one step more
than the start of the line where the opening curly brace is.

This default style is called 'special_inside_parentheses'. Alternative
styles are 'consistent' and 'align_braces'. Here are examples:

### Examples

#### EnforcedStyle: special_inside_parentheses (default)

```ruby
# The `special_inside_parentheses` style enforces that the first key
# in a hash literal where the opening brace and the first key are on
# separate lines is indented one step (two spaces) more than the
# position inside the opening parentheses.

# bad
hash = {
  key: :value
}
and_in_a_method_call({
  no: :difference
                     })

# good
special_inside_parentheses
hash = {
  key: :value
}
but_in_a_method_call({
                       its_like: :this
                     })
```
#### EnforcedStyle: consistent

```ruby
# The `consistent` style enforces that the first key in a hash
# literal where the opening brace and the first key are on
# separate lines is indented the same as a hash literal which is not
# defined inside a method call.

# bad
hash = {
  key: :value
}
but_in_a_method_call({
                       its_like: :this
                      })

# good
hash = {
  key: :value
}
and_in_a_method_call({
  no: :difference
})
```
#### EnforcedStyle: align_braces

```ruby
# The `align_brackets` style enforces that the opening and closing
# braces are indented to the same position.

# bad
and_now_for_something = {
                          completely: :different
}

# good
and_now_for_something = {
                          completely: :different
                        }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `special_inside_parentheses` | `special_inside_parentheses`, `consistent`, `align_braces`
IndentationWidth | `<none>` | Integer

## Layout/IndentFirstParameter

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.68

This cop checks the indentation of the first parameter in a method
definition. Parameters after the first one are checked by
Layout/AlignParameters, not by this cop.

For indenting the first argument of method *calls*, check out
Layout/IndentFirstArgument, which supports options related to
nesting that are irrelevant for method *definitions*.

### Examples

```ruby
# bad
def some_method(
first_param,
second_param)
  123
end
```
#### EnforcedStyle: consistent (default)

```ruby
# The first parameter should always be indented one step more than the
# preceding line.

# good
def some_method(
  first_param,
second_param)
  123
end
```
#### EnforcedStyle: align_parentheses

```ruby
# The first parameter should always be indented one step more than the
# opening parenthesis.

# good
def some_method(
                 first_param,
second_param)
  123
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `consistent` | `consistent`, `align_parentheses`
IndentationWidth | `<none>` | Integer

## Layout/IndentHeredoc

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.69

This cop checks the indentation of the here document bodies. The bodies
are indented one step.
In Ruby 2.3 or newer, squiggly heredocs (`<<~`) should be used. If you
use the older rubies, you should introduce some library to your project
(e.g. ActiveSupport, Powerpack or Unindent).
Note: When `Metrics/LineLength`'s `AllowHeredoc` is false (not default),
      this cop does not add any offenses for long here documents to
      avoid `Metrics/LineLength`'s offenses.

### Examples

#### EnforcedStyle: squiggly (default)

```ruby
# bad
<<-RUBY
something
RUBY

# good
# When EnforcedStyle is squiggly, bad code is auto-corrected to the
# following code.
<<~RUBY
  something
RUBY
```
#### EnforcedStyle: active_support

```ruby
# good
# When EnforcedStyle is active_support, bad code is auto-corrected to
# the following code.
<<-RUBY.strip_heredoc
  something
RUBY
```
#### EnforcedStyle: powerpack

```ruby
# good
# When EnforcedStyle is powerpack, bad code is auto-corrected to
# the following code.
<<-RUBY.strip_indent
  something
RUBY
```
#### EnforcedStyle: unindent

```ruby
# good
# When EnforcedStyle is unindent, bad code is auto-corrected to
# the following code.
<<-RUBY.unindent
  something
RUBY
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `squiggly` | `squiggly`, `active_support`, `powerpack`, `unindent`

### References

* [https://rubystyle.guide#squiggly-heredocs](https://rubystyle.guide#squiggly-heredocs)

## Layout/IndentationConsistency

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for inconsistent indentation.

The difference between `indented_internal_methods` and `normal` is
that the `indented_internal_methods` style prescribes that in
classes and modules the `protected` and `private` modifier keywords
shall be indented the same as public methods and that protected and
private members shall be indented one step more than the modifiers.
Other than that, both styles mean that entities on the same logical
depth shall have the same indentation.

### Examples

#### EnforcedStyle: normal (default)

```ruby
# bad
class A
  def test
    puts 'hello'
     puts 'world'
  end
end

# bad
class A
  def test
    puts 'hello'
    puts 'world'
  end

  protected

    def foo
    end

  private

    def bar
    end
end

# good
class A
  def test
    puts 'hello'
    puts 'world'
  end
end

# good
class A
  def test
    puts 'hello'
    puts 'world'
  end

  protected

  def foo
  end

  private

  def bar
  end
end
```
#### EnforcedStyle: indented_internal_methods

```ruby
# bad
class A
  def test
    puts 'hello'
     puts 'world'
  end
end

# bad
class A
  def test
    puts 'hello'
    puts 'world'
  end

  protected

  def foo
  end

  private

  def bar
  end
end

# good
class A
  def test
    puts 'hello'
    puts 'world'
  end
end

# good
class A
  def test
    puts 'hello'
    puts 'world'
  end

  protected

    def foo
    end

  private

    def bar
    end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `normal` | `normal`, `indented_internal_methods`

### References

* [https://rubystyle.guide#spaces-indentation](https://rubystyle.guide#spaces-indentation)
* [https://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html#follow-the-coding-conventions](https://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html#follow-the-coding-conventions)

## Layout/IndentationWidth

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for indentation that doesn't use the specified number
of spaces.

See also the IndentationConsistency cop which is the companion to this
one.

### Examples

```ruby
# bad
class A
 def test
  puts 'hello'
 end
end

# good
class A
  def test
    puts 'hello'
  end
end
```
#### IgnoredPatterns: ['^\s*module']

```ruby
# bad
module A
class B
  def test
  puts 'hello'
  end
end
end

# good
module A
class B
  def test
    puts 'hello'
  end
end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Width | `2` | Integer
IgnoredPatterns | `[]` | Array

### References

* [https://rubystyle.guide#spaces-indentation](https://rubystyle.guide#spaces-indentation)

## Layout/InitialIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for indentation of the first non-blank non-comment
line in a file.

### Examples

```ruby
# bad
   class A
     def foo; end
   end

# good
class A
  def foo; end
end
```

## Layout/LeadingBlankLines

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.57 | -

This cop checks for unnecessary leading blank lines at the beginning
of a file.

### Examples

```ruby
# bad
# (start of file)

class Foo
end

# bad
# (start of file)

# a comment

# good
# (start of file)
class Foo
end

# good
# (start of file)
# a comment
```

## Layout/LeadingCommentSpace

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.73

This cop checks whether comments have a leading space after the
`#` denoting the start of the comment. The leading space is not
required for some RDoc special syntax, like `#++`, `#--`,
`#:nodoc`, `=begin`- and `=end` comments, "shebang" directives,
or rackup options.

### Examples

```ruby
# bad
#Some comment

# good
# Some comment
```
#### AllowDoxygenCommentStyle: false (default)

```ruby
# bad

#**
# Some comment
# Another line of comment
#*
```
#### AllowDoxygenCommentStyle: true

```ruby
# good

#**
# Some comment
# Another line of comment
#*
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
AllowDoxygenCommentStyle | `false` | Boolean

### References

* [https://rubystyle.guide#hash-space](https://rubystyle.guide#hash-space)

## Layout/MultilineArrayBraceLayout

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks that the closing brace in an array literal is either
on the same line as the last array element or on a new line.

When using the `symmetrical` (default) style:

If an array's opening brace is on the same line as the first element
of the array, then the closing brace should be on the same line as
the last element of the array.

If an array's opening brace is on the line above the first element
of the array, then the closing brace should be on the line below
the last element of the array.

When using the `new_line` style:

The closing brace of a multi-line array literal must be on the line
after the last element of the array.

When using the `same_line` style:

The closing brace of a multi-line array literal must be on the same
line as the last element of the array.

### Examples

#### EnforcedStyle: symmetrical (default)

```ruby
# bad
[ :a,
  :b
]

# bad
[
  :a,
  :b ]

# good
[ :a,
  :b ]

# good
[
  :a,
  :b
]
```
#### EnforcedStyle: new_line

```ruby
# bad
[
  :a,
  :b ]

# bad
[ :a,
  :b ]

# good
[ :a,
  :b
]

# good
[
  :a,
  :b
]
```
#### EnforcedStyle: same_line

```ruby
# bad
[ :a,
  :b
]

# bad
[
  :a,
  :b
]

# good
[
  :a,
  :b ]

# good
[ :a,
  :b ]
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `symmetrical` | `symmetrical`, `new_line`, `same_line`

## Layout/MultilineArrayLineBreaks

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.67 | -

This cop ensures that each item in a multi-line array
starts on a separate line.

### Examples

```ruby
# bad
[
  a, b,
  c
]

# good
[
  a,
  b,
  c
]
```

## Layout/MultilineAssignmentLayout

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.49 | -

This cop checks whether the multiline assignments have a newline
after the assignment operator.

### Examples

#### EnforcedStyle: new_line (default)

```ruby
# bad
foo = if expression
  'bar'
end

# good
foo =
  if expression
    'bar'
  end

# good
foo =
  begin
    compute
  rescue => e
    nil
  end
```
#### EnforcedStyle: same_line

```ruby
# good
foo = if expression
  'bar'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `new_line` | `same_line`, `new_line`

### References

* [https://rubystyle.guide#indent-conditional-assignment](https://rubystyle.guide#indent-conditional-assignment)

## Layout/MultilineBlockLayout

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks whether the multiline do end blocks have a newline
after the start of the block. Additionally, it checks whether the block
arguments, if any, are on the same line as the start of the block.

### Examples

```ruby
# bad
blah do |i| foo(i)
  bar(i)
end

# bad
blah do
  |i| foo(i)
  bar(i)
end

# good
blah do |i|
  foo(i)
  bar(i)
end

# bad
blah { |i| foo(i)
  bar(i)
}

# good
blah { |i|
  foo(i)
  bar(i)
}
```

## Layout/MultilineHashBraceLayout

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks that the closing brace in a hash literal is either
on the same line as the last hash element, or a new line.

When using the `symmetrical` (default) style:

If a hash's opening brace is on the same line as the first element
of the hash, then the closing brace should be on the same line as
the last element of the hash.

If a hash's opening brace is on the line above the first element
of the hash, then the closing brace should be on the line below
the last element of the hash.

When using the `new_line` style:

The closing brace of a multi-line hash literal must be on the line
after the last element of the hash.

When using the `same_line` style:

The closing brace of a multi-line hash literal must be on the same
line as the last element of the hash.

### Examples

#### EnforcedStyle: symmetrical (default)

```ruby
# bad
{ a: 1,
  b: 2
}
# bad
{
  a: 1,
  b: 2 }

# good
{ a: 1,
  b: 2 }

# good
{
  a: 1,
  b: 2
}
```
#### EnforcedStyle: new_line

```ruby
# bad
{
  a: 1,
  b: 2 }

# bad
{ a: 1,
  b: 2 }

# good
{ a: 1,
  b: 2
}

# good
{
  a: 1,
  b: 2
}
```
#### EnforcedStyle: same_line

```ruby
# bad
{ a: 1,
  b: 2
}

# bad
{
  a: 1,
  b: 2
}

# good
{
  a: 1,
  b: 2 }

# good
{ a: 1,
  b: 2 }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `symmetrical` | `symmetrical`, `new_line`, `same_line`

## Layout/MultilineHashKeyLineBreaks

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.67 | -

This cop ensures that each key in a multi-line hash
starts on a separate line.

### Examples

```ruby
# bad
{
  a: 1, b: 2,
  c: 3
}

# good
{
  a: 1,
  b: 2,
  c: 3
}
```

## Layout/MultilineMethodArgumentLineBreaks

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Disabled | Yes | Yes  | 0.67 | -

This cop ensures that each argument in a multi-line method call
starts on a separate line.

### Examples

```ruby
# bad
foo(a, b,
  c
)

# good
foo(
  a,
  b,
  c
)
```

## Layout/MultilineMethodCallBraceLayout

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks that the closing brace in a method call is either
on the same line as the last method argument, or a new line.

When using the `symmetrical` (default) style:

If a method call's opening brace is on the same line as the first
argument of the call, then the closing brace should be on the same
line as the last argument of the call.

If an method call's opening brace is on the line above the first
argument of the call, then the closing brace should be on the line
below the last argument of the call.

When using the `new_line` style:

The closing brace of a multi-line method call must be on the line
after the last argument of the call.

When using the `same_line` style:

The closing brace of a multi-line method call must be on the same
line as the last argument of the call.

### Examples

#### EnforcedStyle: symmetrical (default)

```ruby
# bad
foo(a,
  b
)

# bad
foo(
  a,
  b)

# good
foo(a,
  b)

# good
foo(
  a,
  b
)
```
#### EnforcedStyle: new_line

```ruby
# bad
foo(
  a,
  b)

# bad
foo(a,
  b)

# good
foo(a,
  b
)

# good
foo(
  a,
  b
)
```
#### EnforcedStyle: same_line

```ruby
# bad
foo(a,
  b
)

# bad
foo(
  a,
  b
)

# good
foo(
  a,
  b)

# good
foo(a,
  b)
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `symmetrical` | `symmetrical`, `new_line`, `same_line`

## Layout/MultilineMethodCallIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks the indentation of the method name part in method calls
that span more than one line.

### Examples

#### EnforcedStyle: aligned (default)

```ruby
# bad
while myvariable
.b
  # do something
end

# good
while myvariable
      .b
  # do something
end

# good
Thing.a
     .b
     .c
```
#### EnforcedStyle: indented

```ruby
# good
while myvariable
  .b

  # do something
end
```
#### EnforcedStyle: indented_relative_to_receiver

```ruby
# good
while myvariable
        .a
        .b

  # do something
end

# good
myvariable = Thing
               .a
               .b
               .c
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `aligned` | `aligned`, `indented`, `indented_relative_to_receiver`
IndentationWidth | `<none>` | Integer

## Layout/MultilineMethodDefinitionBraceLayout

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks that the closing brace in a method definition is either
on the same line as the last method parameter, or a new line.

When using the `symmetrical` (default) style:

If a method definition's opening brace is on the same line as the
first parameter of the definition, then the closing brace should be
on the same line as the last parameter of the definition.

If an method definition's opening brace is on the line above the first
parameter of the definition, then the closing brace should be on the
line below the last parameter of the definition.

When using the `new_line` style:

The closing brace of a multi-line method definition must be on the line
after the last parameter of the definition.

When using the `same_line` style:

The closing brace of a multi-line method definition must be on the same
line as the last parameter of the definition.

### Examples

#### EnforcedStyle: symmetrical (default)

```ruby
# bad
def foo(a,
  b
)
end

# bad
def foo(
  a,
  b)
end

# good
def foo(a,
  b)
end

# good
def foo(
  a,
  b
)
end
```
#### EnforcedStyle: new_line

```ruby
# bad
def foo(
  a,
  b)
end

# bad
def foo(a,
  b)
end

# good
def foo(a,
  b
)
end

# good
def foo(
  a,
  b
)
end
```
#### EnforcedStyle: same_line

```ruby
# bad
def foo(a,
  b
)
end

# bad
def foo(
  a,
  b
)
end

# good
def foo(
  a,
  b)
end

# good
def foo(a,
  b)
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `symmetrical` | `symmetrical`, `new_line`, `same_line`

## Layout/MultilineOperationIndentation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks the indentation of the right hand side operand in
binary operations that span more than one line.

### Examples

#### EnforcedStyle: aligned (default)

```ruby
# bad
if a +
    b
  something
end

# good
if a +
   b
  something
end
```
#### EnforcedStyle: indented

```ruby
# bad
if a +
   b
  something
end

# good
if a +
    b
  something
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `aligned` | `aligned`, `indented`
IndentationWidth | `<none>` | Integer

## Layout/RescueEnsureAlignment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks whether the rescue and ensure keywords are aligned
properly.

### Examples

```ruby
# bad
begin
  something
  rescue
  puts 'error'
end

# good
begin
  something
rescue
  puts 'error'
end
```

## Layout/SpaceAfterColon

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for colon (:) not followed by some kind of space.
N.B. this cop does not handle spaces after a ternary operator, which are
instead handled by Layout/SpaceAroundOperators.

### Examples

```ruby
# bad
def f(a:, b:2); {a:3}; end

# good
def f(a:, b: 2); {a: 3}; end
```

### References

* [https://rubystyle.guide#spaces-operators](https://rubystyle.guide#spaces-operators)

## Layout/SpaceAfterComma

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for comma (,) not followed by some kind of space.

### Examples

```ruby
# bad
[1,2]
{ foo:bar,}

# good
[1, 2]
{ foo:bar, }
```

### References

* [https://rubystyle.guide#spaces-operators](https://rubystyle.guide#spaces-operators)

## Layout/SpaceAfterMethodName

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for space between a method name and a left parenthesis in defs.

### Examples

```ruby
# bad
def func (x) end
def method= (y) end

# good
def func(x) end
def method=(y) end
```

### References

* [https://rubystyle.guide#parens-no-spaces](https://rubystyle.guide#parens-no-spaces)

## Layout/SpaceAfterNot

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for space after `!`.

### Examples

```ruby
# bad
! something

# good
!something
```

### References

* [https://rubystyle.guide#no-space-bang](https://rubystyle.guide#no-space-bang)

## Layout/SpaceAfterSemicolon

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for semicolon (;) not followed by some kind of space.

### Examples

```ruby
# bad
x = 1;y = 2

# good
x = 1; y = 2
```

### References

* [https://rubystyle.guide#spaces-operators](https://rubystyle.guide#spaces-operators)

## Layout/SpaceAroundBlockParameters

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks the spacing inside and after block parameters pipes.

### Examples

#### EnforcedStyleInsidePipes: no_space (default)

```ruby
# bad
{}.each { | x,  y |puts x }
->( x,  y ) { puts x }

# good
{}.each { |x, y| puts x }
->(x, y) { puts x }
```
#### EnforcedStyleInsidePipes: space

```ruby
# bad
{}.each { |x,  y| puts x }
->(x,  y) { puts x }

# good
{}.each { | x, y | puts x }
->( x, y ) { puts x }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyleInsidePipes | `no_space` | `space`, `no_space`

## Layout/SpaceAroundEqualsInParameterDefault

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks that the equals signs in parameter default assignments
have or don't have surrounding space depending on configuration.

### Examples

#### EnforcedStyle: space (default)

```ruby
# bad
def some_method(arg1=:default, arg2=nil, arg3=[])
  # do something...
end

# good
def some_method(arg1 = :default, arg2 = nil, arg3 = [])
  # do something...
end
```
#### EnforcedStyle: no_space

```ruby
# bad
def some_method(arg1 = :default, arg2 = nil, arg3 = [])
  # do something...
end

# good
def some_method(arg1=:default, arg2=nil, arg3=[])
  # do something...
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `space` | `space`, `no_space`

### References

* [https://rubystyle.guide#spaces-around-equals](https://rubystyle.guide#spaces-around-equals)

## Layout/SpaceAroundKeyword

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks the spacing around the keywords.

### Examples

```ruby
# bad
something 'test'do|x|
end

while(something)
end

something = 123if test

# good
something 'test' do |x|
end

while (something)
end

something = 123 if test
```

## Layout/SpaceAroundOperators

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks that operators have space around them, except for **
which should not have surrounding space.

### Examples

```ruby
# bad
total = 3*4
"apple"+"juice"
my_number = 38/4
a ** b

# good
total = 3 * 4
"apple" + "juice"
my_number = 38 / 4
a**b
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
AllowForAlignment | `true` | Boolean

### References

* [https://rubystyle.guide#spaces-operators](https://rubystyle.guide#spaces-operators)

## Layout/SpaceBeforeBlockBraces

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.52.1

Checks that block braces have or don't have a space before the opening
brace depending on configuration.

### Examples

#### EnforcedStyle: space (default)

```ruby
# bad
foo.map{ |a|
  a.bar.to_s
}

# good
foo.map { |a|
  a.bar.to_s
}
```
#### EnforcedStyle: no_space

```ruby
# bad
foo.map { |a|
  a.bar.to_s
}

# good
foo.map{ |a|
  a.bar.to_s
}
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `space` | `space`, `no_space`
EnforcedStyleForEmptyBraces | `space` | `space`, `no_space`

## Layout/SpaceBeforeComma

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for comma (,) preceded by space.

### Examples

```ruby
# bad
[1 , 2 , 3]
a(1 , 2)
each { |a , b| }

# good
[1, 2, 3]
a(1, 2)
each { |a, b| }
```

## Layout/SpaceBeforeComment

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for missing space between a token and a comment on the
same line.

### Examples

```ruby
# bad
1 + 1# this operation does ...

# good
1 + 1 # this operation does ...
```

## Layout/SpaceBeforeFirstArg

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks that exactly one space is used between a method name and the
first argument for method calls without parentheses.

Alternatively, extra spaces can be added to align the argument with
something on a preceding or following line, if the AllowForAlignment
config parameter is true.

### Examples

```ruby
# bad
something  x
something   y, z
something'hello'

# good
something x
something y, z
something 'hello'
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
AllowForAlignment | `true` | Boolean

## Layout/SpaceBeforeSemicolon

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for semicolon (;) preceded by space.

### Examples

```ruby
# bad
x = 1 ; y = 2

# good
x = 1; y = 2
```

## Layout/SpaceInLambdaLiteral

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for spaces between `->` and opening parameter
parenthesis (`(`) in lambda literals.

### Examples

#### EnforcedStyle: require_no_space (default)

```ruby
# bad
a = -> (x, y) { x + y }

# good
a = ->(x, y) { x + y }
```
#### EnforcedStyle: require_space

```ruby
# bad
a = ->(x, y) { x + y }

# good
a = -> (x, y) { x + y }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `require_no_space` | `require_no_space`, `require_space`

## Layout/SpaceInsideArrayLiteralBrackets

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.52 | -

Checks that brackets used for array literals have or don't have
surrounding space depending on configuration.

### Examples

#### EnforcedStyle: space

```ruby
# The `space` style enforces that array literals have
# surrounding space.

# bad
array = [a, b, c, d]

# good
array = [ a, b, c, d ]
```
#### EnforcedStyle: no_space (default)

```ruby
# The `no_space` style enforces that array literals have
# no surrounding space.

# bad
array = [ a, b, c, d ]

# good
array = [a, b, c, d]
```
#### EnforcedStyle: compact

```ruby
# The `compact` style normally requires a space inside
# array brackets, with the exception that successive left
# or right brackets are collapsed together in nested arrays.

# bad
array = [ a, [ b, c ] ]
array = [
  [ a ],
  [ b, c ]
]

# good
array = [ a, [ b, c ]]
array = [[ a ],
  [ b, c ]]
```
#### EnforcedStyleForEmptyBrackets: no_space (default)

```ruby
# The `no_space` EnforcedStyleForEmptyBrackets style enforces that
# empty array brackets do not contain spaces.

# bad
foo = [ ]
bar = [     ]

# good
foo = []
bar = []
```
#### EnforcedStyleForEmptyBrackets: space

```ruby
# The `space` EnforcedStyleForEmptyBrackets style enforces that
# empty array brackets contain exactly one space.

# bad
foo = []
bar = [    ]

# good
foo = [ ]
bar = [ ]
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `no_space` | `space`, `no_space`, `compact`
EnforcedStyleForEmptyBrackets | `no_space` | `space`, `no_space`

## Layout/SpaceInsideArrayPercentLiteral

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for unnecessary additional spaces inside array percent literals
(i.e. %i/%w).

### Examples

```ruby
# bad
%w(foo  bar  baz)
# good
%i(foo bar baz)
```

## Layout/SpaceInsideBlockBraces

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks that block braces have or don't have surrounding space inside
them on configuration. For blocks taking parameters, it checks that the
left brace has or doesn't have trailing space depending on
configuration.

### Examples

#### EnforcedStyle: space (default)

```ruby
# The `space` style enforces that block braces have
# surrounding space.

# bad
some_array.each {puts e}

# good
some_array.each { puts e }
```
#### EnforcedStyle: no_space

```ruby
# The `no_space` style enforces that block braces don't
# have surrounding space.

# bad
some_array.each { puts e }

# good
some_array.each {puts e}
```
#### EnforcedStyleForEmptyBraces: no_space (default)

```ruby
# The `no_space` EnforcedStyleForEmptyBraces style enforces that
# block braces don't have a space in between when empty.

# bad
some_array.each {   }
some_array.each {  }
some_array.each { }

# good
some_array.each {}
```
#### EnforcedStyleForEmptyBraces: space

```ruby
# The `space` EnforcedStyleForEmptyBraces style enforces that
# block braces have at least a space in between when empty.

# bad
some_array.each {}

# good
some_array.each { }
some_array.each {  }
some_array.each {   }
```
#### SpaceBeforeBlockParameters: true (default)

```ruby
# The SpaceBeforeBlockParameters style set to `true` enforces that
# there is a space between `{` and `|`. Overrides `EnforcedStyle`
# if there is a conflict.

# bad
[1, 2, 3].each {|n| n * 2 }

# good
[1, 2, 3].each { |n| n * 2 }
```
#### SpaceBeforeBlockParameters: false

```ruby
# The SpaceBeforeBlockParameters style set to `false` enforces that
# there is no space between `{` and `|`. Overrides `EnforcedStyle`
# if there is a conflict.

# bad
[1, 2, 3].each { |n| n * 2 }

# good
[1, 2, 3].each {|n| n * 2 }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `space` | `space`, `no_space`
EnforcedStyleForEmptyBraces | `no_space` | `space`, `no_space`
SpaceBeforeBlockParameters | `true` | Boolean

## Layout/SpaceInsideHashLiteralBraces

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks that braces used for hash literals have or don't have
surrounding space depending on configuration.

### Examples

#### EnforcedStyle: space (default)

```ruby
# The `space` style enforces that hash literals have
# surrounding space.

# bad
h = {a: 1, b: 2}

# good
h = { a: 1, b: 2 }
```
#### EnforcedStyle: no_space

```ruby
# The `no_space` style enforces that hash literals have
# no surrounding space.

# bad
h = { a: 1, b: 2 }

# good
h = {a: 1, b: 2}
```
#### EnforcedStyle: compact

```ruby
# The `compact` style normally requires a space inside
# hash braces, with the exception that successive left
# braces or right braces are collapsed together in nested hashes.

# bad
h = { a: { b: 2 } }
foo = { { a: 1 } => { b: { c: 2 } } }

# good
h = { a: { b: 2 }}
foo = {{ a: 1 } => { b: { c: 2 }}}
```
#### EnforcedStyleForEmptyBraces: no_space (default)

```ruby
# The `no_space` EnforcedStyleForEmptyBraces style enforces that
# empty hash braces do not contain spaces.

# bad
foo = { }
bar = {    }

# good
foo = {}
bar = {}
```
#### EnforcedStyleForEmptyBraces: space

```ruby
# The `space` EnforcedStyleForEmptyBraces style enforces that
# empty hash braces contain space.

# bad
foo = {}

# good
foo = { }
foo = {  }
foo = {     }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `space` | `space`, `no_space`, `compact`
EnforcedStyleForEmptyBraces | `no_space` | `space`, `no_space`

### References

* [https://rubystyle.guide#spaces-operators](https://rubystyle.guide#spaces-operators)

## Layout/SpaceInsideParens

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.55

Checks for spaces inside ordinary round parentheses.

### Examples

#### EnforcedStyle: no_space (default)

```ruby
# The `no_space` style enforces that parentheses do not have spaces.

# bad
f( 3)
g = (a + 3 )

# good
f(3)
g = (a + 3)
```
#### EnforcedStyle: space

```ruby
# The `space` style enforces that parentheses have a space at the
# beginning and end.
# Note: Empty parentheses should not have spaces.

# bad
f(3)
g = (a + 3)
y( )

# good
f( 3 )
g = ( a + 3 )
y()
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `no_space` | `space`, `no_space`

### References

* [https://rubystyle.guide#spaces-braces](https://rubystyle.guide#spaces-braces)

## Layout/SpaceInsidePercentLiteralDelimiters

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for unnecessary additional spaces inside the delimiters of
%i/%w/%x literals.

### Examples

```ruby
# good
%i(foo bar baz)

# bad
%w( foo bar baz )

# bad
%x(  ls -l )
```

## Layout/SpaceInsideRangeLiteral

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

Checks for spaces inside range literals.

### Examples

```ruby
# bad
1 .. 3

# good
1..3

# bad
'a' .. 'z'

# good
'a'..'z'
```

### References

* [https://rubystyle.guide#no-space-inside-range-literals](https://rubystyle.guide#no-space-inside-range-literals)

## Layout/SpaceInsideReferenceBrackets

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.52 | 0.53

Checks that reference brackets have or don't have
surrounding space depending on configuration.

### Examples

#### EnforcedStyle: no_space (default)

```ruby
# The `no_space` style enforces that reference brackets have
# no surrounding space.

# bad
hash[ :key ]
array[ index ]

# good
hash[:key]
array[index]
```
#### EnforcedStyle: space

```ruby
# The `space` style enforces that reference brackets have
# surrounding space.

# bad
hash[:key]
array[index]

# good
hash[ :key ]
array[ index ]
```
#### EnforcedStyleForEmptyBrackets: no_space (default)

```ruby
# The `no_space` EnforcedStyleForEmptyBrackets style enforces that
# empty reference brackets do not contain spaces.

# bad
foo[ ]
foo[     ]

# good
foo[]
```
#### EnforcedStyleForEmptyBrackets: space

```ruby
# The `space` EnforcedStyleForEmptyBrackets style enforces that
# empty reference brackets contain exactly one space.

# bad
foo[]
foo[    ]

# good
foo[ ]
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `no_space` | `space`, `no_space`
EnforcedStyleForEmptyBrackets | `no_space` | `space`, `no_space`

## Layout/SpaceInsideStringInterpolation

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop checks for whitespace within string interpolations.

### Examples

#### EnforcedStyle: no_space (default)

```ruby
# bad
   var = "This is the #{ space } example"

# good
   var = "This is the #{no_space} example"
```
#### EnforcedStyle: space

```ruby
# bad
   var = "This is the #{no_space} example"

# good
   var = "This is the #{ space } example"
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `no_space` | `space`, `no_space`

### References

* [https://rubystyle.guide#string-interpolation](https://rubystyle.guide#string-interpolation)

## Layout/Tab

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.51

This cop checks for tabs inside the source code.

### Examples

```ruby
# bad
# This example uses a tab to indent bar.
def foo
  bar
end

# good
# This example uses spaces to indent bar.
def foo
  bar
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
IndentationWidth | `<none>` | Integer

### References

* [https://rubystyle.guide#spaces-indentation](https://rubystyle.guide#spaces-indentation)

## Layout/TrailingBlankLines

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | -

This cop looks for trailing blank lines and a final newline in the
source code.

### Examples

#### EnforcedStyle: final_blank_line

```ruby
# `final_blank_line` looks for one blank line followed by a new line
# at the end of files.

# bad
class Foo; end
# EOF

# bad
class Foo; end # EOF

# good
class Foo; end

# EOF
```
#### EnforcedStyle: final_newline (default)

```ruby
# `final_newline` looks for one newline at the end of files.

# bad
class Foo; end

# EOF

# bad
class Foo; end # EOF

# good
class Foo; end
# EOF
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
EnforcedStyle | `final_newline` | `final_newline`, `final_blank_line`

### References

* [https://rubystyle.guide#newline-eof](https://rubystyle.guide#newline-eof)

## Layout/TrailingWhitespace

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.49 | 0.55

This cop looks for trailing whitespace in the source code.

### Examples

```ruby
# The line in this example contains spaces after the 0.
# bad
x = 0

# The line in this example ends directly after the 0.
# good
x = 0
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
AllowInHeredoc | `false` | Boolean

### References

* [https://rubystyle.guide#no-trailing-whitespace](https://rubystyle.guide#no-trailing-whitespace)
