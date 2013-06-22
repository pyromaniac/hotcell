module Hotcell
  class Block < Hotcell::Command
    class_attribute :_subcommands, instance_writter: false
    self._subcommands = {}

    def self.subcommands values = nil, &block
      if values.is_a? Hash
        self._subcommands = _subcommands.merge(values.stringify_keys)
      elsif values && block
        subcommands values.to_s => Class.new(Hotcell::Command, &block)
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
          "Unexpected subcommand `#{subcommand.name}` for `#{name}` command",
          *subcommand.name.hotcell_position
        ) unless _subcommands.key?(subcommand.name)
      end
    end

    def subnodes
      options[:subnodes] || []
    end

    def subcommands
      subnodes.select { |node| node.is_a?(Hotcell::Command) }
    end
  end
end
