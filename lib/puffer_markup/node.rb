module PufferMarkup
  class Node
    attr_accessor :name, :children, :options

    def self.build *args
      new(*args).optimize
    end

    def initialize name, *args
      @name = name
      @options = args.extract_options!
      @children = args
    end

    def optimize
      self
    end

    def render context
      raise NotImplementedError
    end

    def values context
      children.map do |child|
        child.is_a?(PufferMarkup::Node) ? child.render(context) : child
      end
    end

    def == other
      other.is_a?(self.class) &&
      name == other.name &&
      options == other.options &&
      children == other.children
    end
  end
end

require 'puffer_markup/node/calculator'
require 'puffer_markup/node/assigner'
require 'puffer_markup/node/summoner'
require 'puffer_markup/node/arrayer'
require 'puffer_markup/node/hasher'
require 'puffer_markup/node/sequencer'
require 'puffer_markup/node/document'
