module Hotcell
  module Commands
    class For < Hotcell::Block
      class Forloop < Hotcell::Manipulator

        def initialize object, index
          @object, @index0 = object, index
        end

        def prev
          @next ||= @object[index0 - 1] if index0 - 1 >= 0
        end

        def next
          @next ||= @object[index0 + 1]
        end

        def length
          @length ||= @object.size
        end
        alias_method :size, :length
        alias_method :count, :length

        def index
          @index ||= index0 + 1
        end

        attr_reader :index0

        def rindex
          @rindex ||= length - index0
        end

        def rindex0
          @rindex ||= length - index
        end

        def first
          @first ||= index0 == 0
        end
        alias_method :first?, :first

        def last
          @last ||= index == length
        end
        alias_method :last?, :last
      end

      def validate!
        raise Hotcell::ArgumentError.new(
          "Wrond number of arguments for `#{name}` (#{children.count} for 2)", *name.hotcell_position
        ) if children.count != 2

        raise Hotcell::SyntaxError.new(
          "Expected IDENTIFER as first argument in `#{name}` command", *name.hotcell_position
        ) unless children[0].is_a?(Hotcell::Summoner)

        children[0] = children[0].name
      end

      def process context, variable, options
        forloop = options['loop'] == true ? 'loop' : options['loop']
        items = Array.wrap(options['in'])
        length = items.size

        items.map.with_index do |item, index|
          scope = { variable => item }
          scope.merge!(forloop => Forloop.new(item, index)) if forloop

          context.scoped scope do
            render_subnodes(context)
          end
        end
      end
    end
  end
end

Hotcell.register_command for: Hotcell::Commands::For
