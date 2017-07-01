# frozen_string_literal: true
require 'rubocop'
require 'regexp-examples'

module RuboCop
  class RegexCop < RuboCop::Cop::Cop
    OFFENSE = %{
It's better to move regex to constants with example instead of direct using it.
It will allow you to reuse this regex and provide instructions for others.

```ruby
CONST_NAME = %{constant} # "%{example}"
%{fixed_string}
```
    }
    SELF_DESCRIPTIVE = %w(
      /[[:alnum:]]/
      /[[:alpha:]]/
      /[[:blank:]]/
      /[[:cntrl:]]/
      /[[:digit:]]/
      /[[:graph:]]/
      /[[:lower:]]/
      /[[:print:]]/
      /[[:punct:]]/
      /[[:space:]]/
      /[[:upper:]]/
      /[[:xdigit:]]/
      /[[:word:]]/
      /[[:ascii:]]/
    )

    def on_regexp(node)
      return if node.parent.type == :casgn
      return if SELF_DESCRIPTIVE.include?(node.source)
      return if node.child_nodes.any? { |child_node| child_node.type == :begin }
      add_offense(node, :expression, OFFENSE % {
        constant: node.source,
        fixed_string: node.source_range.source_line.sub(node.source, 'CONST_NAME').lstrip,
        example: Regexp.new(node.to_a.first.to_a.first).examples.sample
      })
    end
  end
end
