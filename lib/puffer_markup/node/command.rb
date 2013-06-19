module PufferMarkup
  class Command < PufferMarkup::Node
    attr_reader :mode, :assign

    def initialize *_
      super
      @mode = options[:mode] || :normal
      @assign = options[:assign]
    end

    def optimize
      if klass = PufferMarkup.commands[name]
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
