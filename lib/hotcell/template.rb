module Hotcell
  class Template
    attr_reader :source, :options

    def self.parse source
      new source,
        commands: Hotcell.commands,
        blocks: Hotcell.blocks
    end

    def initialize source, options = {}
      @source = Source.wrap(source, options.delete(:file))
      @options = options
    end

    def syntax
      @syntax ||= Parser.new(source, options.slice(:commands, :blocks)).parse
    end

    def render context = {}
      if context.is_a?(Context)
        syntax.render(context)
      else
        default_context = { helpers: Hotcell.helpers }
        syntax.render(Context.new(default_context.merge!(context)))
      end
    end
  end
end
