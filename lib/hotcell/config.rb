require 'singleton'

module Hotcell
  class Config
    include Singleton

    attr_reader :commands, :blocks, :helpers

    def initialize
      @commands = {}
      @blocks = {}
      @helpers = []
    end

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

    def register_helpers *helpers
      @helpers |= helpers.flatten
    end
  end
end
