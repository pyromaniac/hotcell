module Hotcell
  module Commands
    class Include < Hotcell::Command
      def process context, *arguments
        locals = arguments.extract_options!
        path = arguments.first

        context.scoped locals do
          template(path, context).render(context)
        end
      end

      def template path, context
        resolver = context.shared[:resolver] || Hotcell.resolver
        resolver.template(path, context)
      end
    end
  end
end

Hotcell.register_command include: Hotcell::Commands::Include
