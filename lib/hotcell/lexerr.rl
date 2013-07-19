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

  action Interpolate {
    @braces_count = 0;
    emit_interpolation
    fcall interpolation;
  }

  action OpenBrace {
    emit_operator
    @braces_count += 1
  }

  action CloseBrace {
    if @braces_count < 1
      emit_interpolation
      fret;
    else
      emit_operator
      @braces_count -= 1
    end
  }

  action ParseDstring {
    @dstring_start = @ts
    emit_dstring_open
    fcall dstring;
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

    if cs == puffer_lexer_en_dstring
      @ts = @dstring_start
      raise_unterminated_string
    end

    @token_array
  end
end
