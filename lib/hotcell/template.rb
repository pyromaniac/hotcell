module Hotcell
  class Template
    attr_reader :source, :options

    def self.parse source
      new source,
        commands: Hotcell.commands.keys,
        blocks: Hotcell.blocks.keys,
        subcommands: Hotcell.subcommands.keys
    end

    def initialize source, options = {}
      @source = source
      @options = options
    end

    def syntax
      @syntax ||= Parser.new(source, options.slice(:commands, :blocks, :subcommands)).parse
    end

    def render context = {}
      if context.is_a?(Context)
        syntax.render(context)
      else
        syntax.render(Context.new(context))
      end
    end
  end
end
