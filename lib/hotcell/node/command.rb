module Hotcell
  class Command < Hotcell::Node
    def validate!
    end

    def process context, *args
    end

    def render context
      context.safe do
        process(context, *render_children(context))
      end
    end
  end
end
