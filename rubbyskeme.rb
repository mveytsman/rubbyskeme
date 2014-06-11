require 'pry'
require_relative './types'
require_relative './environment'
module RubbySkeme

end
def tokenize(str)
  if str[0] != '(' || str[-1] != ')'
    raise "Not a form"
  end
  str = str[1..-2]
  str.gsub('(',' ( ').gsub(')', ' ) ').split(' ')
end


def parse(toks)
  l = RubbySkeme::Types::List.new
  while toks.length > 0
    tok = toks.shift
    case tok
    when '('
      l << parse(toks)
    when ')'
      return l
    else
      l << RubbySkeme::Types::Atom.make(tok)
    end
  end
  l
end

while true
  print '> '
  s = gets.chomp
  if s[0] != "(" && s =~ /[^\s]/
    l = RubbySkeme::Types::Atom.make(s)
  else
    l = parse(tokenize(s))
  end
  print l.ewal
  print "\n"
end

