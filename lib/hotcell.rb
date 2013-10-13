require 'active_support/all'
require 'set'
require 'hotcell/version'
require 'hotcell/resolver'
require 'hotcell/config'
require 'hotcell/errors'

module Hotcell
  def self.config; Config.instance; end

  singleton_class.delegate :commands, :blocks, :helpers, :register_command, :register_helpers,
    :resolver, :resolver=, :escape_tags, :escape_tags=, to: :config
end

require 'hotcell/tong'
require 'hotcell/extensions'
require 'hotcell/source'
require 'hotcell/lexer'
require 'hotcell/lexerr'
require 'hotcell/lexerc'
require 'hotcell/parser'
require 'hotcell/node'
require 'hotcell/commands'
require 'hotcell/context'
require 'hotcell/template'
