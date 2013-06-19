require 'singleton'

module Hotcell
  class Config
    include Singleton

    attr_reader :commands, :blocks, :subcommands

    def initialize
      @commands = {}
      @blocks = {}
      @subcommands = {}
    end

    def register_command name, klass
      name = name.to_s
      if klass < ::Hotcell::Block
        raise "Command `#{name}` already defined, you can not define block with the same name" if commands.key?(name)
        blocks[name] = klass
        klass.subcommands.each do |subcommand|
          subcommands[subcommand] = klass
        end
      elsif klass < ::Hotcell::Command
        raise "Block `#{name}` already defined, you can not define command with the same name" if blocks.key?(name)
        commands[name] = klass
      else
        raise "Cannot register command `#{name}` because handler is not a Hotcell::Command or Hotcell::Block"
      end
    end
  end
end
