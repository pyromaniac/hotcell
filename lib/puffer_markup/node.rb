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

    def [] key
      children[key]
    end

    def render context
      process context, *render_nodes(context, children)
    end

    def process context, *values
      raise NotImplementedError
    end

    def render_nodes context, *values
      values.flatten.map do |node|
        node.is_a?(PufferMarkup::Node) ? node.render(context) : node
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
require 'puffer_markup/node/joiner'
require 'puffer_markup/node/tag'
require 'puffer_markup/node/command'
require 'puffer_markup/node/block'
