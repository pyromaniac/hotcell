require 'active_support/all'
require 'hotcell/version'
require 'hotcell/config'
require 'hotcell/errors'

module Hotcell
  [:commands, :blocks, :subcommands, :helpers, :register_command, :register_helpers].each do |method|
    define_singleton_method method do |*args|
      Config.instance.send(method, *args)
    end
  end
end

require 'hotcell/lexer'
require 'hotcell/parser'
require 'hotcell/node'
require 'hotcell/commands'
require 'hotcell/context'
require 'hotcell/manipulator'
require 'hotcell/extensions'
require 'hotcell/template'
