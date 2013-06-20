module Hotcell
  class Block < Hotcell::Command
    class_attribute :_subcommands, instance_writter: false
    self._subcommands = []

    def self.subcommands *names
      if names.any?
        self._subcommands = _subcommands + names.flatten.map(&:to_s)
      else
        _subcommands
      end
    end

    def optimize
      if klass = Hotcell.blocks[name]
        klass.new name, *children, options
      else
        self
      end
    end

    def subnodes
      options[:subnodes] || []
    end

    def subcommands
      subnodes.select { |node| node.is_a?(Hash) }
    end

    def validate!
      valid = subcommands.map { |subcommand| subcommand[:name] } - _subcommands == []
      raise Hotcell::BlockError.new 'Invalid block syntax', *name.hotcell_position unless valid
    end

    def process context, subnodes, *args
    end

    def render context
      context.safe do
        subnodes = render_subnodes(context)
        values = render_nodes(context, children)
        concat context, process(context, subnodes, *values)
      end
    end

    def render_subnodes context
      subnodes.map do |node|
        if node.is_a?(Hash)
          subcommand = { name: node[:name] }
          subcommand.merge!(args: node[:args].render(context)) if node[:args]
          subcommand
        else
          node.render(context)
        end
      end
    end
  end
end
