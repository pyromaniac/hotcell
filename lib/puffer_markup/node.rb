module PufferMarkup
  class Node
    attr_accessor :name, :children, :options

    def self.build *args
      new(*args).optimize
    end

    def initialize name, *args
      @name = name
      @options = args.extract_options!
      @children = args.flatten
    end

    def optimize
      self
    end

    def render context
    end

    def == other
      other.is_a?(self.class) &&
      name == other.name &&
      options == other.options &&
      children == other.children
    end
  end
end
