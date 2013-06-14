module PufferMarkup
  class Template
    attr_reader :source

    def initialize source
      @source = source
    end

    def syntax
      @syntax ||= Parser.new(source).parse
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
