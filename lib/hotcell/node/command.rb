module Hotcell
  class Command < Hotcell::Node
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
        process(context, *render_nodes(context, children))
      end
    end
  end
end
