module RubbySkeme
  module Types
    # A Type is an Atom, a Pair, or a List
    

    class Atom 
      # An Atom is a Number, a String, or a Symbol
      attr_accessor :value

      #Makes the right kind of atom depending on the token
      def self.make(tok)
        if tok =~ /\A[-+]?[0-9]+\z/
          Number.new(tok.to_i)
        else
          Symbol.new(tok)
        end
      end

      def initialize(val)
        @value = val
      end
      
      def to_s
        @value.to_s
      end

      def to_sym
        @value.to_sym
      end

      def is_def?
        @value == "def"
      end

      def is_lambda?
        @value == "lambda"
      end
    end

    class Number < Atom
      def ewal(env = GLOBAL_ENV)
        @value
      end
    end

    class Symbol < Atom
      def ewal(env = GLOBAL_ENV)
        env.find(@value)
      end
    end

    class List
      attr_accessor :lst

      def initialize(lst = [])
        @lst = lst
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
          argnames = @lst[1]
          unless (argnames.is_a? List) && (argnames.all? { |a| a.is_a? Atom })
            raise "arguments to lambda need to be a list of atoms"
          end
          #
          body = List.new(@lst[2..-1])
          
          Proc.new do |args|
            unless argnames.length == args.length
              raise "incorrect number of arguments supplied to function"
            end
            lambda_env = env.create_child(Hash[argnames.map(&:to_sym).zip(args)])
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
      def method_missing(sym, *args, &block)
        @lst.send sym, *args, &block
      end
    end
  end
end
