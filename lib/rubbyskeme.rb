require 'pry'
require_relative './things'
require_relative './environment'

module RubbySkeme
  include Things
  def self.tokenize(str)
    if str[0] != '(' || str[-1] != ')'
      raise "Not a form"
    end
    str = str[1..-2]
    str.gsub('(',' ( ').gsub(')', ' ) ').split(' ')
  end


  def self.parse(toks)
    l = List.new
    while toks.length > 0
      tok = toks.shift
      case tok
      when '('
        l << parse(toks)
      when ')'
        return l
      else
        l << Atom.make(tok)
      end
    end
    l
  end

  def self.repl
    while true
      print '> '
      s = gets.chomp
      if s[0] != "(" && s =~ /[^\s]/
        l = Atom.make(s)
      else
        l = parse(tokenize(s))
      end
      print l.ewal
      print "\n"
    end
  end
end
