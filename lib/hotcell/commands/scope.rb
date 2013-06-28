module Hotcell
  module Commands
    class Scope < Hotcell::Block
      def process context, scope = {}
        context.scoped scope do
          subnodes.first.try(:render, context)
        end
      end
    end
  end
end

Hotcell.register_command scope: Hotcell::Commands::Scope
