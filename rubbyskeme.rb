require 'pry'

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

class List
  attr_accessor :lst

  def initialize(lst = [])
    @lst = lst
  end
  
  def <<(obj)
    @lst << obj
  end

  def to_s
    @lst.to_s
  end

  def ewal(env = GLOBAL_ENV)
    operator = @lst[0]
    if operator.is_def?
      unless @lst.length == 3
        raise "def should have 2 arguments"
      end
      name = @lst[1]
      value = @lst[2].ewal
      env.add(name,value)
    elsif operator.is_lambda?
      arglist = @lst[1]
      unless arglist.is_a? List
        raise "arguments to lambda need to be a list"
      end
      #
      body = List.new(@lst[2..-1])
      
      Proc.new do |args|
        argname = :a
        lambda_env = env.create_child({:a => args[0]})
        
        for form in body.lst
          ret = form.ewal(lambda_env)
        end
        ret
      end
      
    elsif operator.is_a? Atom
      func = env.find(@lst[0])
      func.call(lst[1..-1].map{ |x| x.ewal(env) })
    elsif operator.is_a? List
      func = operator.ewal.call(lst[1..-1].map{ |x| x.ewal(env) })
    end
  end
end

class Atom
  attr_accessor :value, :type
  def initialize(tok)
    if tok =~ /\A[-+]?[0-9]+\z/
      @value = tok.to_i
      @type = :int
    else
      @value = tok
      @type = :symbol
    end
  end

  def to_s
    @value.to_s
  end

  def to_sym
    @value.to_sym
  end

  def ewal(env = GLOBAL_ENV)
    if @type == :int
      @value
    elsif @type == :symbol
      env.find(@value)
    end
  end

  def is_def?
    @value == "def"
  end

  def is_lambda?
    @value == "lambda"
  end
end

def tokenize(str)
  if str[0] != '(' || str[-1] != ')'
    raise "Not a form"
  end
  str = str[1..-2]
  str.gsub('(',' ( ').gsub(')', ' ) ').split(' ')
end


def parse(toks)
  l = List.new
  while toks.length > 0
    tok = toks.shift
    case tok
    when '('
      l << parse(toks)
    when ')'
      return l
    else
      l << Atom.new(tok)
    end
  end
  l
end

while true
  print '> '
  s = gets.chomp
  if s[0] != "(" && s =~ /[^\s]/
    l = Atom.new(s)
  else
    l = parse(tokenize(s))
  end
  print l.ewal
  print "\n"
end


(print 1)
