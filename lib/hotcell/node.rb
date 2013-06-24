module Hotcell
  class Node
    attr_accessor :name, :children, :options
    attr_reader :position, :source

    def self.build *args
      new(*args).optimize
    end

    def initialize name, *args
      @name = name
      @options = args.extract_options!
      @source = @options.delete(:source)
      @position = @options.delete(:position)
      @children = args
    end

    def position_info
      source.info(position).values_at(:line, :column)
    end

    def optimize
      self
    end

    def [] key
      children[key]
    end

    def render context
      process context, *render_children(context)
    end

    def process context, *values
      raise NotImplementedError
    end

    def render_nodes context, *values
      values.flatten.map do |node|
        node.is_a?(Hotcell::Node) ? node.render(context) : node
      end
    end

    def render_children context
      render_nodes context, children
    end

    def == other
      other.is_a?(self.class) &&
      name == other.name &&
      options == other.options &&
      children == other.children
    end
  end
end

require 'hotcell/node/calculator'
require 'hotcell/node/assigner'
require 'hotcell/node/summoner'
require 'hotcell/node/arrayer'
require 'hotcell/node/hasher'
require 'hotcell/node/sequencer'
require 'hotcell/node/joiner'
require 'hotcell/node/tag'
require 'hotcell/node/command'
require 'hotcell/node/block'
