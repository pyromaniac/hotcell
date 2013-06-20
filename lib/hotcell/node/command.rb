module Hotcell
  class Command < Hotcell::Node
    def mode
      options[:mode] || :normal
    end

    def assign
      options[:assign]
    end

    def optimize
      if klass = Hotcell.commands[name]
        klass.new name, *children, options
      else
        self
      end
    end

    def validate!
    end

    def process context, *args
    end

    def render context
      context.safe do
        concat context, process(context, *render_nodes(context, children))
      end
    end

    def concat context, result
      context[assign] = result if assign
      case mode
      when :normal
        result
      else
        ''
      end
    end
  end
end
