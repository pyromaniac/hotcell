require 'singleton'

module Hotcell
  class Config
    include Singleton

    attr_reader :commands, :blocks, :helpers
    attr_accessor :resolver

    def initialize
      @commands = {}
      @blocks = {}
      @helpers = []
      @resolver = Hotcell::Resolver.new
    end

    # Adds command or block to the list of default commands or blocks returned
    # by `Hotcell.commands` and `Hotcell.blocks` accessors respectively
    #
    # Usage:
    #
    #   Hotcell.register_command :block, BlockClass
    #   Hotcell.register_command :command, CommandClass
    #   Hotcell.register_command block: BlockClass, command: CommandClass
    #
    def register_command name, klass = nil
      if name.is_a? Hash
        name.each do |(name, klass)|
          register_command name, klass
        end
        return
      end

      name = name.to_s
      if klass < ::Hotcell::Block
        raise "Command `#{name}` already defined, you can not define block with the same name" if commands.key?(name)
        blocks[name] = klass
      elsif klass < ::Hotcell::Command
        raise "Block `#{name}` already defined, you can not define command with the same name" if blocks.key?(name)
        commands[name] = klass
      else
        raise "Cannot register command `#{name}` because handler is not a Hotcell::Command or Hotcell::Block"
      end
    end

    # Adds helper to the list of default helpers, accessible by `Hotcell.helpers`
    #
    # Usage:
    #
    #   Hotcell.register_helpers Helper
    #   Hotcell.register_helpers Helper1, Helper2
    #   Hotcell.register_helpers helpers_array
    #
    def register_helpers *helpers
      @helpers |= helpers.flatten
    end
  end
end
