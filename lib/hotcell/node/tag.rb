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
        values = render_nodes(context, children)
        case mode
        when :normal
          process context, *values
        else
          ''
        end
      end
    end
  end
end
