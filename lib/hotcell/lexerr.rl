%%{
  machine puffer_lexer;

  variable data @data;
  variable te @te;
  variable ts @ts;
  variable p @p;

  action RegexpCheck {
    if (!regexp_possible)
      emit_operator;
      fgoto expression;
    end
  }

  include "lexer.rl";
}%%

Hotcell::Lexer.class_eval do
  def current_position
    @ts
  end

  def current_value
    @data[@ts...@te].pack(Hotcell::Source::PACK_MODE).force_encoding(@source.encoding)
  end

  def current_error
    value = @data[@ts..@p].pack(Hotcell::Source::PACK_MODE).force_encoding(@source.encoding)
    [value, *@source.info(@ts).values_at(:line, :column)]
  end

  def tokenize
    %% write data;
    #%

    @data = @source.data
    @token_array = []

    %% write init;
    #%

    eof = pe
    stack = []

    %% write exec;
    #%

    raise_unexpected_symbol unless @ts.nil?

    @token_array
  end
end
