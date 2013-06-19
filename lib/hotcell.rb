require 'active_support/all'
require 'hotcell/version'
require 'hotcell/config'
require 'hotcell/errors'
require 'hotcell/lexer'
require 'hotcell/parser'
require 'hotcell/node'
require 'hotcell/context'
require 'hotcell/manipulator'
require 'hotcell/extensions'
require 'hotcell/template'

module Hotcell
  [:commands, :blocks, :subcommands, :helpers, :register_command, :register_helpers].each do |method|
    define_singleton_method method do
      Config.instance.send(method)
    end
  end
end
