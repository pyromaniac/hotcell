module Hotcell
  class Tag < Hotcell::Node
    attr_reader :mode

    def initialize *_
      super
      @mode = options[:mode] || :normal
    end

    def process context, *values
      values.last
    end

    def render context
      context.safe do
        concat context, process(context, *render_children(context))
      end
    end

    def concat context, result
      case mode
      when :silence
        ''
      when :escape
        ERB::Util.html_escape_once(result)
      else
        result.to_s
      end
    end
  end
end
