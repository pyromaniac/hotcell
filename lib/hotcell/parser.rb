#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.9
# from Racc grammer file "".
#

require 'racc/parser.rb'

  require 'hotcell/lexer'
module Hotcell
  class Parser < Racc::Parser

module_eval(<<'...end parser.y/module_eval...', 'parser.y', 176)
  NEWLINE_PRED = Set.new(Lexer::BOPEN.values + Lexer::OPERATIONS.values)
  NEWLINE_NEXT = Set.new(Lexer::BCLOSE.values + [:NEWLINE])

  TAG_MODES = { '{{' => :normal, '{{!' => :silence }

  def initialize string, options = {}
    @lexer = Lexer.new(string)
    @tokens = @lexer.tokens
    @position = -1

    @commands = Set.new(Array.wrap(options[:commands]).map(&:to_s))
    @blocks = Set.new(Array.wrap(options[:blocks]).map(&:to_s))
    @endblocks = Set.new(Array.wrap(options[:blocks]).map { |identifer| "end#{identifer}" })
    @subcommands = Set.new(Array.wrap(options[:subcommands]).map(&:to_s))
  end

  def parse
    if @tokens.size == 0
      Joiner.build :JOINER
    else
      do_parse
    end
  end

  def next_token
    @position = @position + 1

    tcurr = @tokens[@position]
    tnext = @tokens[@position.next]
    tpred = @tokens[@position.pred]

    if tcurr && (tcurr[0] == :COMMENT || tcurr[0] == :NEWLINE && (
      (tpred && NEWLINE_PRED.include?(tpred[0])) ||
      (tnext && NEWLINE_NEXT.include?(tnext[0]))
    ))
      next_token
    else
      if tcurr && tcurr[0] == :IDENTIFER
        if @commands.include?(tcurr[1])
          [:COMMAND, tcurr[1]]
        elsif @blocks.include?(tcurr[1])
          [:BLOCK, tcurr[1]]
        elsif @endblocks.include?(tcurr[1])
          [:ENDBLOCK, tcurr[1]]
        elsif @subcommands.include?(tcurr[1])
          [:SUBCOMMAND, tcurr[1]]
        elsif tcurr[1] == 'end'
          [:END, tcurr[1]]
        else
          tcurr
        end
      else
        tcurr || [false, false]
      end
    end
  end

  def on_error(token, value, vstack)
    raise Hotcell::Errors::UnexpectedLexem.new("#{token_to_str(token) || '?'} `#{value}`",
      value.hotcell_position[0], value.hotcell_position[1])
  end
...end parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    42,    10,    26,   106,    92,   141,   103,    92,    25,    24,
   135,    61,    81,    82,     7,    44,    42,   103,    26,   104,
    90,    62,    21,    22,    25,    24,    62,   132,    65,     7,
     8,   134,    62,   131,    27,    87,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   133,   130,   104,    51,    52,
    27,   127,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   129,    26,    81,    82,   106,    81,    82,    25,    24,
    68,   105,    67,    69,    72,    62,    42,   142,    26,     7,
     8,    54,    21,    22,    25,    24,    12,    16,    18,    19,
    53,    81,    82,    49,    27,    68,    35,    36,    37,    38,
    39,    40,    41,    43,    65,    81,    82,    81,    82,    68,
    27,    68,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   106,    26,    51,    52,     7,    44,    50,    25,    24,
   nil,    81,    82,    81,    82,    68,    42,    68,    26,    67,
    69,    72,    70,    71,    25,    24,    81,    82,    57,   nil,
    68,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    57,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,    81,    82,   nil,    42,    68,    26,    67,
    69,    72,    70,    71,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,    81,    82,   nil,    42,    68,    26,    67,
    69,    72,    70,    71,    25,    24,   nil,   nil,    57,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,    81,    82,   nil,    42,    68,    26,    67,
    69,    72,    70,    71,    25,    24,   nil,   nil,    57,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,    81,    82,    25,    24,
    68,   nil,    67,    69,    72,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    57,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,    88,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,    21,    22,    25,    24,    12,    16,    18,    19,
    95,    96,    97,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    57,   nil,   nil,   nil,   nil,   nil,
    27,   110,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,   nil,   nil,    25,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    42,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    25,    24,   nil,   nil,    65,   nil,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    65,   nil,   nil,   nil,   nil,   nil,
    27,   nil,    35,    36,    37,    38,    39,    40,    41,    43,
    42,   nil,    26,   nil,   nil,   nil,    81,    82,    25,    24,
    68,   nil,    67,    69,    72,    70,    71,    75,    76,    77,
    78,    79,    80,    73,    74,   nil,   nil,    16,    65,    19,
   nil,   nil,   nil,   nil,    27,   nil,    35,    36,    37,    38,
    39,    40,    41,    43,    81,    82,   nil,   nil,    68,   nil,
    67,    69,    72,    70,    71,    75,    76,    77,    78,    79,
    80,    73,    74,    81,    82,   nil,   nil,    68,   nil,    67,
    69,    72,    70,    71,    75,    76,    77,    78,    79,    80,
    73,    74,    81,    82,   nil,   nil,    68,   nil,    67,    69,
    72,    70,    71,    75,    76,    77,    78,    79,    80,    73,
    74,    81,    82,   nil,   nil,    68,   nil,    67,    69,    72,
    70,    71,    75,    76,    77,    78,    79,    80,    73,    74,
    81,    82,   nil,   nil,    68,   nil,    67,    69,    72,    70,
    71,    75,    76,    77,    78,    79,    80,    73,    81,    82,
   nil,   nil,    68,   nil,    67,    69,    72,    70,    71,    75,
    76,    77,    78,   -92,   -92,    81,    82,   nil,   nil,    68,
   nil,    67,    69,    72,    70,    71,    75,    76,    77,    78,
   -92,   -92,    81,    82,   nil,   nil,    68,   nil,    67,    69,
    72,    70,    71,    75,    76,    77,    78,    79,    80 ]

racc_action_check = [
    27,     1,    27,    91,    43,   111,    65,   106,    27,    27,
    96,    18,    85,    85,     9,     9,   103,    57,   103,    57,
    43,    65,    27,    27,   103,   103,    18,    91,    27,     1,
     1,    94,    57,    89,    27,    27,    27,    27,    27,    27,
    27,    27,    27,    27,   103,    93,    89,    92,    86,    86,
   103,    81,   103,   103,   103,   103,   103,   103,   103,   103,
     8,    86,     8,    84,    84,    59,   116,   116,     8,     8,
   116,    58,   116,   116,   116,   127,   104,   128,   104,     0,
     0,    15,     8,     8,   104,   104,     8,     8,     8,     8,
    14,   117,   117,    10,     8,   117,     8,     8,     8,     8,
     8,     8,     8,     8,   104,   114,   114,    83,    83,   114,
   104,    83,   104,   104,   104,   104,   104,   104,   104,   104,
   105,   139,   105,    13,    13,    45,    45,    13,   105,   105,
   nil,   113,   113,   122,   122,   113,    82,   122,    82,   122,
   122,   122,   122,   122,    82,    82,   112,   112,   105,   nil,
   112,   nil,   nil,   nil,   105,   nil,   105,   105,   105,   105,
   105,   105,   105,   105,    82,   nil,   nil,   nil,   nil,   nil,
    82,   nil,    82,    82,    82,    82,    82,    82,    82,    82,
    80,   nil,    80,   nil,   nil,   nil,   nil,   nil,    80,    80,
   nil,   nil,   nil,   123,   123,   nil,   131,   123,   131,   123,
   123,   123,   123,   123,   131,   131,   nil,   nil,    80,   nil,
   nil,   nil,   nil,   nil,    80,   nil,    80,    80,    80,    80,
    80,    80,    80,    80,   131,   nil,   nil,   nil,   nil,   nil,
   131,   nil,   131,   131,   131,   131,   131,   131,   131,   131,
    16,   nil,    16,   nil,   nil,   nil,   nil,   nil,    16,    16,
   nil,   nil,   nil,   121,   121,   nil,    79,   121,    79,   121,
   121,   121,   121,   121,    79,    79,   nil,   nil,    16,   nil,
   nil,   nil,   nil,   nil,    16,   nil,    16,    16,    16,    16,
    16,    16,    16,    16,    79,   nil,   nil,   nil,   nil,   nil,
    79,   nil,    79,    79,    79,    79,    79,    79,    79,    79,
    19,   nil,    19,   nil,   nil,   nil,   nil,   nil,    19,    19,
   nil,   nil,   nil,   120,   120,   nil,    21,   120,    21,   120,
   120,   120,   120,   120,    21,    21,   nil,   nil,    19,   nil,
   nil,   nil,   nil,   nil,    19,   nil,    19,    19,    19,    19,
    19,    19,    19,    19,    21,   nil,   nil,   nil,   nil,   nil,
    21,   nil,    21,    21,    21,    21,    21,    21,    21,    21,
    22,   nil,    22,   nil,   nil,   nil,   115,   115,    22,    22,
   115,   nil,   115,   115,   115,   nil,    78,   nil,    78,   nil,
   nil,   nil,   nil,   nil,    78,    78,   nil,   nil,    22,   nil,
   nil,   nil,   nil,   nil,    22,   nil,    22,    22,    22,    22,
    22,    22,    22,    22,    78,   nil,   nil,   nil,   nil,   nil,
    78,   nil,    78,    78,    78,    78,    78,    78,    78,    78,
    24,   nil,    24,   nil,   nil,   nil,   nil,   nil,    24,    24,
   nil,   nil,   nil,   nil,   nil,   nil,    25,   nil,    25,   nil,
   nil,   nil,   nil,   nil,    25,    25,   nil,   nil,    24,   nil,
   nil,   nil,   nil,   nil,    24,   nil,    24,    24,    24,    24,
    24,    24,    24,    24,    25,   nil,   nil,   nil,   nil,   nil,
    25,   nil,    25,    25,    25,    25,    25,    25,    25,    25,
    26,   nil,    26,   nil,   nil,   nil,   nil,   nil,    26,    26,
   nil,   nil,   nil,   nil,   nil,   nil,    97,   nil,    97,   nil,
   nil,   nil,   nil,   nil,    97,    97,   nil,   nil,    26,   nil,
   nil,   nil,   nil,   nil,    26,   nil,    26,    26,    26,    26,
    26,    26,    26,    26,    97,   nil,   nil,   nil,   nil,   nil,
    97,   nil,    97,    97,    97,    97,    97,    97,    97,    97,
    42,   nil,    42,   nil,   nil,   nil,   nil,   nil,    42,    42,
   nil,   nil,   nil,   nil,   nil,   nil,    77,   nil,    77,   nil,
   nil,   nil,   nil,   nil,    77,    77,   nil,   nil,    42,   nil,
   nil,   nil,   nil,    42,    42,   nil,    42,    42,    42,    42,
    42,    42,    42,    42,    77,   nil,   nil,   nil,   nil,   nil,
    77,   nil,    77,    77,    77,    77,    77,    77,    77,    77,
    44,   nil,    44,   nil,   nil,   nil,   nil,   nil,    44,    44,
   nil,   nil,   nil,   nil,   nil,   nil,    76,   nil,    76,   nil,
   nil,   nil,    44,    44,    76,    76,    44,    44,    44,    44,
    44,    44,    44,   nil,    44,   nil,    44,    44,    44,    44,
    44,    44,    44,    44,    76,   nil,   nil,   nil,   nil,   nil,
    76,   nil,    76,    76,    76,    76,    76,    76,    76,    76,
    51,   nil,    51,   nil,   nil,   nil,   nil,   nil,    51,    51,
   nil,   nil,   nil,   nil,   nil,   nil,    52,   nil,    52,   nil,
   nil,   nil,   nil,   nil,    52,    52,   nil,   nil,    51,   nil,
   nil,   nil,   nil,   nil,    51,   nil,    51,    51,    51,    51,
    51,    51,    51,    51,    52,   nil,   nil,   nil,   nil,   nil,
    52,   nil,    52,    52,    52,    52,    52,    52,    52,    52,
    75,   nil,    75,   nil,   nil,   nil,   nil,   nil,    75,    75,
   nil,   nil,   nil,   nil,   nil,   nil,    74,   nil,    74,   nil,
   nil,   nil,   nil,   nil,    74,    74,   nil,   nil,    75,   nil,
   nil,   nil,   nil,   nil,    75,   nil,    75,    75,    75,    75,
    75,    75,    75,    75,    74,   nil,   nil,   nil,   nil,   nil,
    74,   nil,    74,    74,    74,    74,    74,    74,    74,    74,
    73,   nil,    73,   nil,   nil,   nil,   nil,   nil,    73,    73,
   nil,   nil,   nil,   nil,   nil,   nil,    72,   nil,    72,   nil,
   nil,   nil,   nil,   nil,    72,    72,   nil,   nil,    73,   nil,
   nil,   nil,   nil,   nil,    73,   nil,    73,    73,    73,    73,
    73,    73,    73,    73,    72,   nil,   nil,   nil,   nil,   nil,
    72,   nil,    72,    72,    72,    72,    72,    72,    72,    72,
    70,   nil,    70,   nil,   nil,   nil,   nil,   nil,    70,    70,
   nil,   nil,   nil,   nil,   nil,   nil,    62,   nil,    62,   nil,
   nil,   nil,   nil,   nil,    62,    62,   nil,   nil,    70,   nil,
   nil,   nil,   nil,   nil,    70,   nil,    70,    70,    70,    70,
    70,    70,    70,    70,    62,   nil,   nil,   nil,   nil,   nil,
    62,    62,    62,    62,    62,    62,    62,    62,    62,    62,
    71,   nil,    71,   nil,   nil,   nil,   nil,   nil,    71,    71,
   nil,   nil,   nil,   nil,   nil,   nil,    67,   nil,    67,   nil,
   nil,   nil,   nil,   nil,    67,    67,   nil,   nil,    71,   nil,
   nil,   nil,   nil,   nil,    71,   nil,    71,    71,    71,    71,
    71,    71,    71,    71,    67,   nil,   nil,   nil,   nil,   nil,
    67,   nil,    67,    67,    67,    67,    67,    67,    67,    67,
    68,   nil,    68,   nil,   nil,   nil,   nil,   nil,    68,    68,
   nil,   nil,   nil,   nil,   nil,   nil,    69,   nil,    69,   nil,
   nil,   nil,   nil,   nil,    69,    69,   nil,   nil,    68,   nil,
   nil,   nil,   nil,   nil,    68,   nil,    68,    68,    68,    68,
    68,    68,    68,    68,    69,   nil,   nil,   nil,   nil,   nil,
    69,   nil,    69,    69,    69,    69,    69,    69,    69,    69,
    61,   nil,    61,   nil,   nil,   nil,   109,   109,    61,    61,
   109,   nil,   109,   109,   109,   109,   109,   109,   109,   109,
   109,   109,   109,   109,   109,   nil,   nil,    61,    61,    61,
   nil,   nil,   nil,   nil,    61,   nil,    61,    61,    61,    61,
    61,    61,    61,    61,   137,   137,   nil,   nil,   137,   nil,
   137,   137,   137,   137,   137,   137,   137,   137,   137,   137,
   137,   137,   137,    56,    56,   nil,   nil,    56,   nil,    56,
    56,    56,    56,    56,    56,    56,    56,    56,    56,    56,
    56,    56,    23,    23,   nil,   nil,    23,   nil,    23,    23,
    23,    23,    23,    23,    23,    23,    23,    23,    23,    23,
    23,   138,   138,   nil,   nil,   138,   nil,   138,   138,   138,
   138,   138,   138,   138,   138,   138,   138,   138,   138,   138,
   119,   119,   nil,   nil,   119,   nil,   119,   119,   119,   119,
   119,   119,   119,   119,   119,   119,   119,   119,   124,   124,
   nil,   nil,   124,   nil,   124,   124,   124,   124,   124,   124,
   124,   124,   124,   124,   124,   125,   125,   nil,   nil,   125,
   nil,   125,   125,   125,   125,   125,   125,   125,   125,   125,
   125,   125,   118,   118,   nil,   nil,   118,   nil,   118,   118,
   118,   118,   118,   118,   118,   118,   118,   118,   118 ]

racc_action_pointer = [
    51,     1,   nil,   nil,   nil,   nil,   nil,   nil,    56,   -14,
    93,   nil,   nil,    97,    60,    51,   236,   nil,   -12,   296,
   nil,   312,   356,  1099,   416,   432,   476,    -4,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   536,   -28,   596,    97,   nil,   nil,   nil,   nil,
   nil,   656,   672,   nil,   nil,   nil,  1080,    -6,    47,    41,
   nil,  1016,   852,   nil,   nil,   -17,   nil,   912,   956,   972,
   836,   896,   792,   776,   732,   716,   612,   552,   372,   252,
   176,    19,   132,   104,    60,     9,    22,   nil,   nil,     9,
   nil,   -21,    22,    15,     1,   nil,   -23,   492,   nil,   nil,
   nil,   nil,   nil,    12,    72,   116,   -25,   nil,   nil,  1023,
   nil,   -34,   143,   128,   102,   363,    63,    88,  1189,  1137,
   310,   250,   130,   190,  1155,  1172,   nil,    37,    40,   nil,
   nil,   192,   nil,   nil,   nil,   nil,   nil,  1061,  1118,    97,
   nil,   nil,   nil ]

racc_action_default = [
   -92,   -92,    -2,    -3,    -4,    -5,    -6,    -7,   -92,   -92,
   -92,    -1,    -8,   -92,   -92,   -92,   -20,   -22,   -89,   -24,
   -26,   -35,   -39,   -40,   -92,   -92,   -92,   -92,   -63,   -64,
   -65,   -66,   -67,   -68,   -69,   -70,   -71,   -72,   -73,   -74,
   -75,   -76,   -92,   -92,   -92,   -92,   -15,   -16,   -17,   143,
    -9,   -33,   -37,   -10,   -11,   -21,   -80,   -89,   -87,   -88,
   -84,   -92,   -92,   -25,   -34,   -89,   -38,   -92,   -92,   -92,
   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,
   -92,   -92,   -92,   -47,   -48,   -57,   -92,   -61,   -77,   -92,
   -81,   -92,   -92,   -92,   -92,   -28,   -92,   -30,   -13,   -14,
   -18,   -32,   -36,   -92,   -92,   -92,   -92,   -23,   -27,   -58,
   -90,   -92,   -41,   -42,   -43,   -44,   -45,   -46,   -49,   -50,
   -51,   -52,   -53,   -54,   -55,   -56,   -59,   -89,   -92,   -62,
   -78,   -92,   -82,   -12,   -19,   -29,   -31,   -85,   -79,   -86,
   -83,   -91,   -60 ]

racc_goto_table = [
    56,    55,    48,    56,    63,    47,    91,   107,    83,    84,
    85,    94,    64,    66,    45,   108,    93,   126,    86,    89,
     2,    11,     1,   140,   nil,   nil,    56,   nil,   nil,    46,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   100,   nil,
   nil,    99,   101,   102,   nil,   109,    56,   111,   nil,   nil,
   nil,   112,   113,   114,   115,   116,   117,   118,   119,   120,
   121,   122,   123,   124,   125,    98,    56,   128,   139,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    56,   136,   nil,   nil,   nil,   nil,   109,   137,   138,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   138 ]

racc_goto_check = [
    19,    17,    11,    19,    17,    14,    28,    16,    19,    19,
    19,    15,     7,     7,    13,    18,    12,    20,     7,    27,
     2,     2,     1,    29,   nil,   nil,    19,   nil,   nil,     2,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    11,   nil,
   nil,    14,     7,     7,   nil,    19,    19,    17,   nil,   nil,
   nil,    19,    19,    19,    19,    19,    19,    19,    19,    19,
    19,    19,    19,    19,    19,     2,    19,    17,    28,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    19,    17,   nil,   nil,   nil,   nil,    19,    19,    19,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    19 ]

racc_goto_pointer = [
   nil,    22,    20,   nil,   nil,   nil,   nil,    -9,   nil,   nil,
   nil,    -7,   -28,     5,    -4,   -33,   -54,   -15,   -46,   -16,
   -64,   nil,   nil,   nil,   nil,   nil,   nil,   -23,   -37,   -83 ]

racc_goto_default = [
   nil,   nil,   nil,     3,     4,     5,     6,    13,    14,     9,
    15,   nil,   nil,   nil,   nil,   nil,    17,   nil,    20,    23,
    34,    28,    29,    30,    31,    32,    33,    58,    59,    60 ]

racc_reduce_table = [
  0, 0, :racc_error,
  2, 50, :_reduce_1,
  1, 50, :_reduce_2,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 52, :_reduce_7,
  2, 55, :_reduce_8,
  3, 55, :_reduce_9,
  3, 53, :_reduce_10,
  3, 58, :_reduce_11,
  3, 60, :_reduce_none,
  2, 62, :_reduce_13,
  2, 62, :_reduce_14,
  1, 62, :_reduce_15,
  1, 62, :_reduce_16,
  2, 54, :_reduce_none,
  3, 54, :_reduce_18,
  3, 63, :_reduce_19,
  1, 65, :_reduce_20,
  2, 65, :_reduce_21,
  1, 57, :_reduce_22,
  3, 57, :_reduce_23,
  1, 67, :_reduce_24,
  2, 67, :_reduce_25,
  1, 59, :_reduce_26,
  3, 59, :_reduce_27,
  1, 61, :_reduce_none,
  2, 61, :_reduce_none,
  1, 64, :_reduce_30,
  2, 64, :_reduce_31,
  3, 56, :_reduce_32,
  2, 56, :_reduce_none,
  2, 56, :_reduce_34,
  1, 56, :_reduce_35,
  3, 56, :_reduce_36,
  2, 56, :_reduce_none,
  2, 56, :_reduce_38,
  1, 56, :_reduce_39,
  1, 56, :_reduce_40,
  3, 68, :_reduce_41,
  3, 68, :_reduce_42,
  3, 68, :_reduce_43,
  3, 68, :_reduce_44,
  3, 68, :_reduce_45,
  3, 68, :_reduce_46,
  2, 68, :_reduce_47,
  2, 68, :_reduce_48,
  3, 68, :_reduce_49,
  3, 68, :_reduce_50,
  3, 68, :_reduce_51,
  3, 68, :_reduce_52,
  3, 68, :_reduce_53,
  3, 68, :_reduce_54,
  3, 68, :_reduce_55,
  3, 68, :_reduce_56,
  2, 68, :_reduce_57,
  3, 68, :_reduce_58,
  3, 68, :_reduce_59,
  4, 68, :_reduce_60,
  2, 68, :_reduce_61,
  3, 68, :_reduce_62,
  1, 68, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 71, :_reduce_none,
  1, 71, :_reduce_none,
  1, 71, :_reduce_none,
  1, 72, :_reduce_none,
  1, 72, :_reduce_none,
  1, 73, :_reduce_none,
  1, 73, :_reduce_none,
  2, 74, :_reduce_77,
  3, 74, :_reduce_78,
  3, 76, :_reduce_79,
  1, 76, :_reduce_80,
  2, 75, :_reduce_81,
  3, 75, :_reduce_82,
  3, 77, :_reduce_83,
  1, 77, :_reduce_84,
  3, 78, :_reduce_85,
  3, 66, :_reduce_86,
  1, 66, :_reduce_none,
  1, 66, :_reduce_88,
  1, 69, :_reduce_89,
  3, 69, :_reduce_90,
  4, 69, :_reduce_91 ]

racc_reduce_n = 92

racc_shift_n = 143

racc_token_table = {
  false => 0,
  :error => 1,
  :NEGATIVE => 2,
  :PERIOD => 3,
  :AOPEN => 4,
  :UPLUS => 5,
  :NOT => 6,
  :POWER => 7,
  :UMINUS => 8,
  :MULTIPLY => 9,
  :DIVIDE => 10,
  :MODULO => 11,
  :PLUS => 12,
  :MINUS => 13,
  :GT => 14,
  :GTE => 15,
  :LT => 16,
  :LTE => 17,
  :EQUAL => 18,
  :INEQUAL => 19,
  :AND => 20,
  :OR => 21,
  :TERNARY => 22,
  :ASSIGN => 23,
  :COMMA => 24,
  :COLON => 25,
  :SEMICOLON => 26,
  :NEWLINE => 27,
  :TEMPLATE => 28,
  :TOPEN => 29,
  :TCLOSE => 30,
  :COMMAND => 31,
  :IDENTIFER => 32,
  :BLOCK => 33,
  :ENDBLOCK => 34,
  :END => 35,
  :SUBCOMMAND => 36,
  :ACLOSE => 37,
  :POPEN => 38,
  :PCLOSE => 39,
  :NIL => 40,
  :TRUE => 41,
  :FALSE => 42,
  :INTEGER => 43,
  :FLOAT => 44,
  :STRING => 45,
  :REGEXP => 46,
  :HOPEN => 47,
  :HCLOSE => 48 }

racc_nt_base = 49

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "NEGATIVE",
  "PERIOD",
  "AOPEN",
  "UPLUS",
  "NOT",
  "POWER",
  "UMINUS",
  "MULTIPLY",
  "DIVIDE",
  "MODULO",
  "PLUS",
  "MINUS",
  "GT",
  "GTE",
  "LT",
  "LTE",
  "EQUAL",
  "INEQUAL",
  "AND",
  "OR",
  "TERNARY",
  "ASSIGN",
  "COMMA",
  "COLON",
  "SEMICOLON",
  "NEWLINE",
  "TEMPLATE",
  "TOPEN",
  "TCLOSE",
  "COMMAND",
  "IDENTIFER",
  "BLOCK",
  "ENDBLOCK",
  "END",
  "SUBCOMMAND",
  "ACLOSE",
  "POPEN",
  "PCLOSE",
  "NIL",
  "TRUE",
  "FALSE",
  "INTEGER",
  "FLOAT",
  "STRING",
  "REGEXP",
  "HOPEN",
  "HCLOSE",
  "$start",
  "document",
  "document_unit",
  "template",
  "command_tag",
  "block_tag",
  "tag",
  "sequence",
  "assigned_command",
  "block_open",
  "assigned_block",
  "block_close",
  "endblock",
  "block_body",
  "subcommand_tag",
  "subcommand",
  "command",
  "arguments",
  "block",
  "expr",
  "method",
  "value",
  "const",
  "number",
  "string",
  "array",
  "hash",
  "params",
  "pairs",
  "pair" ]

Racc_debug_parser = true

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'parser.y', 54)
  def _reduce_1(val, _values, result)
     val[0].children.push(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 55)
  def _reduce_2(val, _values, result)
     result = Joiner.build :JOINER, val[0] 
    result
  end
.,.,

# reduce 3 omitted

# reduce 4 omitted

# reduce 5 omitted

# reduce 6 omitted

module_eval(<<'.,.,', 'parser.y', 58)
  def _reduce_7(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 59)
  def _reduce_8(val, _values, result)
     result = Tag.build :TAG, mode: TAG_MODES[val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 60)
  def _reduce_9(val, _values, result)
     result = Tag.build :TAG, *val[1].flatten, mode: TAG_MODES[val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 63)
  def _reduce_10(val, _values, result)
        command = val[1][:command]
    assign = val[1][:assign]
    command.options[:mode] = TAG_MODES[val[0]]
    command.options[:assign] = assign if assign
    command.validate!
    result = command
  
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 71)
  def _reduce_11(val, _values, result)
        block = val[1][:block]
    assign = val[1][:assign]
    block.options[:mode] = TAG_MODES[val[0]]
    block.options[:assign] = assign if assign
    result = block
  
    result
  end
.,.,

# reduce 12 omitted

module_eval(<<'.,.,', 'parser.y', 79)
  def _reduce_13(val, _values, result)
                    val[0][-1].is_a?(Joiner) ?
                  val[0][-1].children.push(val[1]) :
                  val[0].push(Joiner.build(:JOINER, val[1]))
              
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 83)
  def _reduce_14(val, _values, result)
     val[0].push(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 84)
  def _reduce_15(val, _values, result)
     result = [Joiner.build(:JOINER, val[0])] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 85)
  def _reduce_16(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

# reduce 17 omitted

module_eval(<<'.,.,', 'parser.y', 87)
  def _reduce_18(val, _values, result)
     val[0].options[:subnodes] = val[1]; val[0].validate! 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 88)
  def _reduce_19(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 90)
  def _reduce_20(val, _values, result)
     result = Command.build val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 91)
  def _reduce_21(val, _values, result)
     result = Command.build val[0], *val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 92)
  def _reduce_22(val, _values, result)
     result = { command: val[0] } 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 93)
  def _reduce_23(val, _values, result)
     result = { command: val[2], assign: val[0] } 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 94)
  def _reduce_24(val, _values, result)
     result = Block.build val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 95)
  def _reduce_25(val, _values, result)
     result = Block.build val[0], *val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 96)
  def _reduce_26(val, _values, result)
     result = { block: val[0] } 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 97)
  def _reduce_27(val, _values, result)
     result = { block: val[2], assign: val[0] } 
    result
  end
.,.,

# reduce 28 omitted

# reduce 29 omitted

module_eval(<<'.,.,', 'parser.y', 100)
  def _reduce_30(val, _values, result)
     result = { name: val[0] } 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 101)
  def _reduce_31(val, _values, result)
     result = { name: val[0], args: Arrayer.build(:ARRAY, *val[1]) } 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 103)
  def _reduce_32(val, _values, result)
     result = val[0].push(val[2]) 
    result
  end
.,.,

# reduce 33 omitted

module_eval(<<'.,.,', 'parser.y', 105)
  def _reduce_34(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 106)
  def _reduce_35(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 107)
  def _reduce_36(val, _values, result)
     result = val[0].push(val[2]) 
    result
  end
.,.,

# reduce 37 omitted

module_eval(<<'.,.,', 'parser.y', 109)
  def _reduce_38(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 110)
  def _reduce_39(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 111)
  def _reduce_40(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 113)
  def _reduce_41(val, _values, result)
     result = Calculator.build :MULTIPLY, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 114)
  def _reduce_42(val, _values, result)
     result = Calculator.build :POWER, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 115)
  def _reduce_43(val, _values, result)
     result = Calculator.build :DIVIDE, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 116)
  def _reduce_44(val, _values, result)
     result = Calculator.build :PLUS, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 117)
  def _reduce_45(val, _values, result)
     result = Calculator.build :MINUS, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 118)
  def _reduce_46(val, _values, result)
     result = Calculator.build :MODULO, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 119)
  def _reduce_47(val, _values, result)
     result = Calculator.build :UMINUS, val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 120)
  def _reduce_48(val, _values, result)
     result = Calculator.build :UPLUS, val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 121)
  def _reduce_49(val, _values, result)
     result = Calculator.build :AND, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 122)
  def _reduce_50(val, _values, result)
     result = Calculator.build :OR, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 123)
  def _reduce_51(val, _values, result)
     result = Calculator.build :GT, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 124)
  def _reduce_52(val, _values, result)
     result = Calculator.build :GTE, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 125)
  def _reduce_53(val, _values, result)
     result = Calculator.build :LT, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 126)
  def _reduce_54(val, _values, result)
     result = Calculator.build :LTE, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 127)
  def _reduce_55(val, _values, result)
     result = Calculator.build :EQUAL, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 128)
  def _reduce_56(val, _values, result)
     result = Calculator.build :INEQUAL, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 129)
  def _reduce_57(val, _values, result)
     result = Calculator.build :NOT, val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 130)
  def _reduce_58(val, _values, result)
     result = Assigner.build val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 131)
  def _reduce_59(val, _values, result)
     val[2].children[0] = val[0]; result = val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 132)
  def _reduce_60(val, _values, result)
     result = Summoner.build val[0], '[]', *val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 133)
  def _reduce_61(val, _values, result)
     result = nil 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 135)
  def _reduce_62(val, _values, result)
            result = case val[1].size
        when 0
          nil
        when 1
          val[1][0]
        else
          Sequencer.build :SEQUENCE, *val[1].flatten
        end
      
    result
  end
.,.,

# reduce 63 omitted

# reduce 64 omitted

# reduce 65 omitted

# reduce 66 omitted

# reduce 67 omitted

# reduce 68 omitted

# reduce 69 omitted

# reduce 70 omitted

# reduce 71 omitted

# reduce 72 omitted

# reduce 73 omitted

# reduce 74 omitted

# reduce 75 omitted

# reduce 76 omitted

module_eval(<<'.,.,', 'parser.y', 154)
  def _reduce_77(val, _values, result)
     result = Arrayer.build :ARRAY 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 155)
  def _reduce_78(val, _values, result)
     result = Arrayer.build :ARRAY, *val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 156)
  def _reduce_79(val, _values, result)
     val[0].push(val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 157)
  def _reduce_80(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 159)
  def _reduce_81(val, _values, result)
     result = Hasher.build :HASH 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 160)
  def _reduce_82(val, _values, result)
     result = Hasher.build :HASH, *val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 161)
  def _reduce_83(val, _values, result)
     val[0].push(val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 162)
  def _reduce_84(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 163)
  def _reduce_85(val, _values, result)
     result = Arrayer.build :PAIR, val[0], val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 165)
  def _reduce_86(val, _values, result)
     result = [*val[0], Hasher.build(:HASH, *val[2])] 
    result
  end
.,.,

# reduce 87 omitted

module_eval(<<'.,.,', 'parser.y', 167)
  def _reduce_88(val, _values, result)
     result = Hasher.build(:HASH, *val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 168)
  def _reduce_89(val, _values, result)
     result = Summoner.build nil, val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 169)
  def _reduce_90(val, _values, result)
     result = Summoner.build nil, val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 170)
  def _reduce_91(val, _values, result)
     result = Summoner.build nil, val[0], *val[2] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class Parser
  end   # module Hotcell