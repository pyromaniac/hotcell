module Hotcell
  module Commands
    class Unless < Hotcell::Block
      subcommand else: Hotcell::Commands::If::Else
      validate_arguments_count 1

      def validate!
        raise Hotcell::BlockError.new(
          "Unexpected `#{subcommands[1].name}` for `#{name}` command",
          *subcommands[1].position_info
        ) if subcommands[1]

        super
      end

      def process context, condition
        condition ? subnodes[2].try(:render, context) : subnodes[0].try(:render, context)
      end
    end
  end
end

Hotcell.register_command unless: Hotcell::Commands::Unless
