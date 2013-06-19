require 'singleton'

module PufferMarkup
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
      if klass < ::PufferMarkup::Block
        raise "Command `#{name}` already defined, you can not define block with the same name" if commands.key?(name)
        blocks[name] = klass
        klass.subcommands.each do |subcommand|
          subcommands[subcommand] = klass
        end
      elsif klass < ::PufferMarkup::Command
        raise "Block `#{name}` already defined, you can not define command with the same name" if blocks.key?(name)
        commands[name] = klass
      else
        raise "Cannot register command `#{name}` because handler is not a PufferMarkup::Command or PufferMarkup::Block"
      end
    end
  end
end
