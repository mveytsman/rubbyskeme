require 'pry'
require_relative 'types'
module RubbySkeme
  include RubbySkeme::Types
  class Environment
    attr_accessor :map, :parent
    def initialize(map = {}, parent = nil)
      @map = map
      @parent = parent
    end

    def create_child(map = {})
      Environment.new(map, self)
    end

    def find(key)
      # binding.pry
      @map[key.to_sym] || @parent.find(key)
    end

    def add(name, value)
      @map[name.to_sym] = value
    end
  end

  GLOBAL_ENV = Environment.new(
               {:+ => Proc.new { |lst| lst.inject(:+)}}
             )

  

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
