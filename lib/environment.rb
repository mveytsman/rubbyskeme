module RubbySkeme
  
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
