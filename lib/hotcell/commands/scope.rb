module Hotcell
  module Commands
    class Scope < Hotcell::Block
      def validate!
        raise Hotcell::SyntaxError.new(
          "Expected first argument to be a HASH in `#{name}`", *name.hotcell_position
        ) if children.first && !children.first.is_a?(Hotcell::Hasher)

        super
      end

      def process context, scope = {}
        context.scoped scope do
          subnodes.first.try(:render, context)
        end
      end
    end
  end
end

Hotcell.register_command scope: Hotcell::Commands::Scope
