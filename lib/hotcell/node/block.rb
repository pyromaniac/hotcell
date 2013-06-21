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

    def validate!
      subcommands.each do |subcommand|
        raise Hotcell::BlockError.new(
          "Unexpected subcommand `#{subcommand[:name]}` for `#{name}` command",
          *subcommand[:name].hotcell_position
        ) unless _subcommands.include?(subcommand[:name])
      end
    end

    def subnodes
      options[:subnodes] || []
    end

    def subcommands
      subnodes.select { |node| node.is_a?(Hash) }
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
