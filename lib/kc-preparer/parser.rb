
require 'kramdown/parser/kramdown'

#
# Custom Kramdown parser to handle things
#

class Kramdown::Parser::KCPreparerKramdown < Kramdown::Parser::Kramdown

   def initialize(source, options)
     super
     @span_parsers.unshift(:escaped_line_break)
   end

   ESCAPED_LINE_BREAK_START = /\\\n/m

   def parse_escaped_line_break
     @src.pos += @src.matched_size
     @tree.children << Element.new(:br)
   end

   define_parser(:escaped_line_break, ESCAPED_LINE_BREAK_START, "\\\n")
end
