require 'active_support/all'
require 'puffer_markup/version'
require 'puffer_markup/config'
require 'puffer_markup/errors'
require 'puffer_markup/lexer'
require 'puffer_markup/parser'
require 'puffer_markup/node'
require 'puffer_markup/context'
require 'puffer_markup/hotcell'
require 'puffer_markup/extensions'
require 'puffer_markup/template'

module PufferMarkup
  [:commands, :blocks, :subcommands, :register_command].each do |method|
    define_singleton_method method do
      Config.instance.send(method)
    end
  end
end
