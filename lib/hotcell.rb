require 'active_support/all'
require 'hotcell/version'
require 'hotcell/resolver'
require 'hotcell/config'
require 'hotcell/errors'

module Hotcell
  def self.config; Config.instance; end

  singleton_class.delegate :commands, :blocks, :helpers, :register_command, :register_helpers,
    :resolver, :resolver=, to: :config
end

require 'hotcell/manipulator'
require 'hotcell/extensions'
require 'hotcell/lexer'
require 'hotcell/parser'
require 'hotcell/node'
require 'hotcell/commands'
require 'hotcell/context'
require 'hotcell/source'
require 'hotcell/template'
