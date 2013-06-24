module Hotcell
  class Block < Hotcell::Command
    class_attribute :subcommands, instance_writter: false, instance_reader: false
    self.subcommands = {}

    def self.subcommand name_or_hash, &block
      if name_or_hash.is_a? Hash
        self.subcommands = subcommands.merge(name_or_hash.stringify_keys)
      else
        subcommand name_or_hash => Class.new(Hotcell::Command, &block)
      end
    end

    def validate!
      subcommands.each do |subcommand|
        raise Hotcell::BlockError.new(
          "Unexpected subcommand `#{subcommand.name}` for `#{name}` command",
          *subcommand.position_info
        ) unless self.class.subcommands.key?(subcommand.name)
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
