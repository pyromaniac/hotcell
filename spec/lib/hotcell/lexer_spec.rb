# encoding: UTF-8
require 'spec_helper'

describe Hotcell::Lexer do
  def scan template
    described_class.new(template).tokens.map { |token| [token[0], token[1][0]] }
  end

  def expression template
    scan("{{ #{template} }}")[1..-2]
  end

  specify { scan('').should == [] }
  specify { scan('{{ }}').should == [[:TOPEN, "{{"], [:TCLOSE, "}}"]] }
  specify { expression('').should == [] }

  context 'arithmetic' do
    specify { expression('+').should == [[:PLUS, '+']] }
    specify { expression('-').should == [[:MINUS, '-']] }
    specify { expression('*').should == [[:MULTIPLY, '*']] }
    specify { expression('* *').should == [[:MULTIPLY, '*'], [:MULTIPLY, '*']] }
    specify { expression('**').should == [[:POWER, '**']] }
    specify { expression('/').should == [[:DIVIDE, '/']] }
    specify { expression('%').should == [[:MODULO, '%']] }
  end

  context 'logic' do
    specify { expression('&&').should == [[:AND, '&&']] }
    specify { expression('||').should == [[:OR, '||']] }
    specify { expression('!').should == [[:NOT, '!']] }
    specify { expression('!!').should == [[:NOT, '!'], [:NOT, '!']] }
    specify { expression('==').should == [[:EQUAL, '==']] }
    specify { expression('!=').should == [[:INEQUAL, '!=']] }
    specify { expression('! =').should == [[:NOT, '!'], [:ASSIGN, '=']] }
    specify { expression('>').should == [[:GT, '>']] }
    specify { expression('>=').should == [[:GTE, '>=']] }
    specify { expression('> =').should == [[:GT, '>'], [:ASSIGN, '=']] }
    specify { expression('<').should == [[:LT, '<']] }
    specify { expression('<=').should == [[:LTE, '<=']] }
    specify { expression('< =').should == [[:LT, '<'], [:ASSIGN, '=']] }
  end

  context 'flow' do
    specify { expression('=').should == [[:ASSIGN, '=']] }
    specify { expression('= =').should == [[:ASSIGN, '='], [:ASSIGN, '=']] }
    specify { expression(',').should == [[:COMMA, ',']] }
    specify { expression('.').should == [[:PERIOD, '.']] }
    specify { expression(':').should == [[:COLON, ':']] }
    specify { expression('?').should == [[:QUESTION, '?']] }
    specify { expression('hello?').should == [[:IDENTIFER, 'hello?']] }
    specify { expression('hello ?').should == [[:IDENTIFER, 'hello'], [:QUESTION, '?']] }
    specify { expression(';').should == [[:SEMICOLON, ';']] }
    specify { expression("\n").should == [[:NEWLINE, "\n"]] }
  end

  context 'structure' do
    specify { expression('[').should == [[:AOPEN, '[']] }
    specify { expression(']').should == [[:ACLOSE, ']']] }
    specify { expression('{').should == [[:HOPEN, '{']] }
    specify { expression('}').should == [[:HCLOSE, '}']] }
    specify { expression('(').should == [[:POPEN, '(']] }
    specify { expression(')').should == [[:PCLOSE, ')']] }
  end

  context 'numeric' do
    context 'integer' do
      specify { expression('42').should == [[:INTEGER, 42]] }
      specify { expression('-42').should == [[:MINUS, '-'], [:INTEGER, 42]] }
      specify { expression('!42').should == [[:NOT, '!'], [:INTEGER, 42]] }
      specify { expression('42.').should == [[:INTEGER, 42], [:PERIOD, '.']] }
      specify { expression('42.foo').should == [[:INTEGER, 42], [:PERIOD, '.'], [:IDENTIFER, 'foo']] }
      specify { expression('42foo').should == [[:INTEGER, 42], [:IDENTIFER, 'foo']] }
    end

    context 'float' do
      specify { expression('42.42').should == [[:FLOAT, 42.42]] }
      specify { expression('-42.42').should == [[:MINUS, '-'], [:FLOAT, 42.42]] }
      specify { expression('!42.42').should == [[:NOT, '!'], [:FLOAT, 42.42]] }
      specify { expression('0.42').should == [[:FLOAT, 0.42]] }
      specify { expression('.42').should == [[:FLOAT, 0.42]] }
      specify { expression('.42.').should == [[:FLOAT, 0.42], [:PERIOD, '.']] }
      specify { expression('.42.foo').should == [[:FLOAT, 0.42], [:PERIOD, '.'], [:IDENTIFER, 'foo']] }
      specify { expression('.42foo').should == [[:FLOAT, 0.42], [:IDENTIFER, 'foo']] }
      specify { expression('..42').should == [[:PERIOD, '.'], [:FLOAT, 0.42]] }
    end
  end

  context 'identifer' do
    specify { expression('foo').should == [[:IDENTIFER, 'foo']] }
    specify { expression('foo42').should == [[:IDENTIFER, 'foo42']] }
    specify { expression('f42').should == [[:IDENTIFER, 'f42']] }
    specify { expression('foo42bar').should == [[:IDENTIFER, 'foo42bar']] }
    specify { expression('42foo42').should == [[:INTEGER, 42], [:IDENTIFER, 'foo42']] }
    specify { expression('foo?').should == [[:IDENTIFER, 'foo?']] }
    specify { expression('foo?bar').should == [[:IDENTIFER, 'foo?'], [:IDENTIFER, 'bar']] }
    specify { expression('foo!').should == [[:IDENTIFER, 'foo!']] }
    specify { expression('foo!bar').should == [[:IDENTIFER, 'foo!'], [:IDENTIFER, 'bar']] }
    specify { expression('foo.bar').should == [[:IDENTIFER, 'foo'], [:PERIOD, '.'], [:IDENTIFER, 'bar']] }
    specify { expression('!foo').should == [[:NOT, '!'], [:IDENTIFER, 'foo']] }
    specify { expression('-foo').should == [[:MINUS, '-'], [:IDENTIFER, 'foo']] }

    context 'constants' do
      specify { expression('nil').should == [[:NIL, nil]] }
      specify { expression('"nil"').should == [[:STRING, 'nil']] }
      specify { expression('null').should == [[:NIL, nil]] }
      specify { expression('"null"').should == [[:STRING, 'null']] }
      specify { expression('false').should == [[:FALSE, false]] }
      specify { expression('"false"').should == [[:STRING, 'false']] }
      specify { expression('true').should == [[:TRUE, true]] }
      specify { expression('"true"').should == [[:STRING, 'true']] }
    end
  end

  context 'string' do
    context 'single quoted' do
      specify { expression(%q{''}).should == [[:STRING, '']] }
      specify { expression(%q{'foo'}).should == [[:STRING, 'foo']] }
      specify { expression(%q{'fo"o'}).should == [[:STRING, 'fo"o']] }
      specify { expression(%q{'fo\o'}).should == [[:STRING, 'fo\o']] }
      specify { expression(%q{'fo\'o'}).should == [[:STRING, 'fo\'o']] }
      specify { expression(%q{'fo\"o'}).should == [[:STRING, 'fo\"o']] }
      specify { expression(%q{'fo\no'}).should == [[:STRING, 'fo\no']] }
      specify { expression(%q{'fo\mo'}).should == [[:STRING, 'fo\mo']] }
      specify { expression(%q{'foo42'}).should == [[:STRING, 'foo42']] }
      specify { expression(%q{'привет'}).should == [[:STRING, 'привет']] }
      specify { expression(%q{'при\вет'}).should == [[:STRING, 'при\вет']] }

      context do
        let(:strings) { data 'sstrings' }

        specify { expression(strings).delete_if { |token| token.first == :NEWLINE }.should == [
          [:STRING, 'fo\'o'], [:STRING, 'fo\o'], [:STRING, 'fo\\o'],
          [:STRING, 'fo\no'], [:STRING, "foo\nbar"]
        ] }
      end
    end

    context 'double quoted' do
      specify { expression(%q{""}).should == [[:STRING, ""]] }
      specify { expression(%q{"foo"}).should == [[:STRING, "foo"]] }
      specify { expression(%q{"fo'o"}).should == [[:STRING, "fo'o"]] }
      specify { expression(%q{"fo\o"}).should == [[:STRING, "fo\o"]] }
      specify { expression(%q{"fo\"o"}).should == [[:STRING, "fo\"o"]] }
      specify { expression(%q{"fo\'o"}).should == [[:STRING, "fo\'o"]] }
      specify { expression(%q{"fo\no"}).should == [[:STRING, "fo\no"]] }
      specify { expression(%q{"fo\mo"}).should == [[:STRING, "fo\mo"]] }
      specify { expression(%q{"foo42"}).should == [[:STRING, "foo42"]] }
      specify { expression(%q{"привет"}).should == [[:STRING, "привет"]] }
      # RBX can not handle this
      # specify { expression(%q{"при\вет"}).should == [[:STRING, "при\вет"]] }

      context do
        let(:strings) { data 'dstrings' }

        specify { expression(strings).delete_if { |token| token.first == :NEWLINE }.should == [
          [:STRING, "fo\"o"], [:STRING, "fo\o"], [:STRING, "fo\\o"],
          [:STRING, "fo\no"], [:STRING, "fo\mo"], [:STRING, "fo\to"],
          [:STRING, "foo\nbar"]
        ] }
      end
    end
  end

  context 'regexp' do
    specify { expression('//').should == [[:REGEXP, //]] }
    specify { expression('/regexp/').should == [[:REGEXP, /regexp/]] }
    specify { expression('/regexp/i').should == [[:REGEXP, /regexp/i]] }
    specify { expression('/regexp/m').should == [[:REGEXP, /regexp/m]] }
    specify { expression('/regexp/x').should == [[:REGEXP, /regexp/x]] }
    specify { expression('/regexp/sdmfri').should == [[:REGEXP, /regexp/im]] }
    specify { expression('/\.*/').should == [[:REGEXP, /\.*/]] }
    # Funny ruby 2.0 bug. regexp1.to_s == regexp2.to_s, but regexp1 != regexp2
    # specify { expression('/\//').should == [[:REGEXP, /\//]] }
    # specify { expression('/\//ix').should == [[:REGEXP, /\//ix]] }
    specify { expression('/\//').to_s.should == [[:REGEXP, /\//]].to_s }
    specify { expression('/\//ix').to_s.should == [[:REGEXP, /\//ix]].to_s }
    specify { expression('/регексп/').should == [[:REGEXP, /регексп/]] }
    specify { expression('/регексп/m').should == [[:REGEXP, /регексп/m]] }

    context 'ambiguity' do
      specify { expression('hello /regexp/').should == [
        [:IDENTIFER, "hello"], [:DIVIDE, "/"], [:IDENTIFER, "regexp"], [:DIVIDE, "/"]
      ] }
      specify { expression('hello(/regexp/)').should == [
        [:IDENTIFER, "hello"], [:POPEN, "("], [:REGEXP, /regexp/], [:PCLOSE, ")"]
      ] }
      specify { expression('[/regexp/]').should == [
        [:AOPEN, "["], [:REGEXP, /regexp/], [:ACLOSE, "]"]
      ] }
      specify { expression('[42, /regexp/]').should == [
        [:AOPEN, "["], [:INTEGER, 42], [:COMMA, ","], [:REGEXP, /regexp/], [:ACLOSE, "]"]
      ] }
      specify { expression('{/regexp/: 42}').should == [
        [:HOPEN, "{"], [:REGEXP, /regexp/], [:COLON, ":"], [:INTEGER, 42], [:HCLOSE, "}"]
      ] }
      specify { expression('42 : /regexp/').should == [
        [:INTEGER, 42], [:COLON, ":"], [:REGEXP, /regexp/]
      ] }
      specify { expression('42; /regexp/').should == [
        [:INTEGER, 42], [:SEMICOLON, ";"], [:REGEXP, /regexp/]
      ] }
      specify { expression('"hello" /regexp/').should == [
        [:STRING, "hello"], [:DIVIDE, "/"], [:IDENTIFER, "regexp"], [:DIVIDE, "/"]
      ] }
    end
  end

  context 'expression comments' do
    specify { scan('{{ # }}').should == [[:TOPEN, '{{'], [:COMMENT, '# '], [:TCLOSE, '}}']] }
    specify { scan('{{ #}}').should == [[:TOPEN, '{{'], [:COMMENT, '#'], [:TCLOSE, '}}']] }
    specify { scan('{{ #hello }}').should == [[:TOPEN, '{{'], [:COMMENT, '#hello '], [:TCLOSE, '}}']] }
    specify { scan('{{ #hello}}').should == [[:TOPEN, '{{'], [:COMMENT, '#hello'], [:TCLOSE, '}}']] }
    specify { scan('{{ #hello}}}').should == [[:TOPEN, '{{'], [:COMMENT, '#hello'], [:TCLOSE, '}}'], [:TEMPLATE, '}']] }
    specify { scan('{{ #hello} }}').should == [[:TOPEN, '{{'], [:COMMENT, '#hello} '], [:TCLOSE, '}}']] }
    specify { scan('{{ #hello# }}').should == [[:TOPEN, '{{'], [:COMMENT, '#hello# '], [:TCLOSE, '}}']] }
    specify { scan('{{ #hello#}}').should == [[:TOPEN, '{{'], [:COMMENT, '#hello#'], [:TCLOSE, '}}']] }
    specify { scan('{{ #hel}lo#}}').should == [[:TOPEN, '{{'], [:COMMENT, '#hel}lo#'], [:TCLOSE, '}}']] }
    specify { scan('{{ #hel{lo#}}').should == [[:TOPEN, '{{'], [:COMMENT, '#hel{lo#'], [:TCLOSE, '}}']] }
    specify { scan("{{ #hel{\nlo#}}").should == [[:TOPEN, "{{"], [:COMMENT, "#hel{"], [:NEWLINE, "\n"],
      [:IDENTIFER, "lo"], [:COMMENT, "#"], [:TCLOSE, "}}"]] }
    specify { scan("{{ #hel{#\n#lo#}}").should == [[:TOPEN, "{{"], [:COMMENT, "#hel{#"], [:NEWLINE, "\n"],
      [:COMMENT, "#lo#"], [:TCLOSE, "}}"]] }
  end

  context 'errors' do
    describe Hotcell::UnexpectedSymbol do
      let(:error) { Hotcell::UnexpectedSymbol }

      specify { expect { expression("hello @world") }.to raise_error(error, /`@`.*1:10/) }
      specify { expect { expression("@hello world") }.to raise_error(error, /`@`.*1:4/) }
      specify { expect { expression("hello world@") }.to raise_error(error, /`@`.*1:15/) }
      specify { expect { expression("hello\n@ world") }.to raise_error(error, /`@`.*2:1/) }
      specify { expect { expression("hello\n @world") }.to raise_error(error, /`@`.*2:2/) }
      specify { expect { expression("hello\n world@") }.to raise_error(error, /`@`.*2:7/) }
      specify { expect { expression("hello@\n world") }.to raise_error(error, /`@`.*1:9/) }
      specify { expect { expression("@hello\n world") }.to raise_error(error, /`@`.*1:4/) }
      specify { expect { expression("'привет' @ 'мир'") }.to raise_error(error, /`@`.*1:13/) }
    end

    describe Hotcell::UnterminatedString do
      let(:error) { Hotcell::UnterminatedString }

      specify { expect { expression("hello 'world") }.to raise_error(error, /`'world }}`.*1:10/) }
      specify { expect { expression("hello\nwor'ld") }.to raise_error(error, /`'ld }}`.*2:4/) }
      specify { expect { expression("hello 'world\\'") }.to raise_error(error, /`'world\\' }}`.*1:10/) }
      specify { expect { expression("hello 'wor\\'ld") }.to raise_error(error, /`'wor\\'ld }}`.*1:10/) }
      specify { expect { expression("\"hello world") }.to raise_error(error, /`"hello world }}`.*1:4/) }
      specify { expect { expression("he\"llo\\\" world") }.to raise_error(error, /`"llo\\" world }}`.*1:6/) }
      specify { expect { expression("he\"llo\\\" \nworld") }.to raise_error(error, /`"llo\\" \nworld }}`.*1:6/) }
      specify { expect { expression("\"hello\\\"\n world") }.to raise_error(error, /`"hello\\"\n world }}`.*1:4/) }
      specify { expect { expression("'привет' 'мир") }.to raise_error(error, /`'мир }}`.*1:13/) }
    end
  end

  context 'complex expressions' do
    specify { expression('3+2 * 9').should == [
      [:INTEGER, 3], [:PLUS, "+"], [:INTEGER, 2],
      [:MULTIPLY, "*"], [:INTEGER, 9]
    ] }
    specify { expression('3 / 2 / 9').should == [
      [:INTEGER, 3], [:DIVIDE, "/"], [:INTEGER, 2],
      [:DIVIDE, "/"], [:INTEGER, 9]
    ] }
    specify { expression("foo.bar.baz('hello', 16)").should == [
      [:IDENTIFER, "foo"], [:PERIOD, "."], [:IDENTIFER, "bar"],
      [:PERIOD, "."], [:IDENTIFER, "baz"], [:POPEN, "("],
      [:STRING, "hello"], [:COMMA, ","], [:INTEGER, 16],
      [:PCLOSE, ")"]
    ] }
    specify { expression("foo(36.6);\n  a = \"привет\"").should == [
      [:IDENTIFER, "foo"], [:POPEN, "("], [:FLOAT, 36.6],
      [:PCLOSE, ")"], [:SEMICOLON, ";"], [:NEWLINE, "\n"],
      [:IDENTIFER, "a"], [:ASSIGN, "="], [:STRING, "привет"]
    ] }
    specify { expression("'foo'.match(\"^foo$\")").should == [
      [:STRING, "foo"], [:PERIOD, "."], [:IDENTIFER, "match"],
      [:POPEN, "("], [:STRING, "^foo$"], [:PCLOSE, ")"]
    ] }
  end

  context 'templates' do
    specify { scan(' ').should == [[:TEMPLATE, " "]] }
    specify { scan('{').should == [[:TEMPLATE, "{"]] }
    specify { scan('}').should == [[:TEMPLATE, "}"]] }
    specify { scan('{{').should == [[:TOPEN, "{{"]] }
    specify { scan('}}').should == [[:TEMPLATE, "}}"]] }
    specify { scan('hello').should == [[:TEMPLATE, "hello"]] }
    specify { scan('hel{lo').should == [[:TEMPLATE, "hel{lo"]] }
    specify { scan('hel{{lo').should == [
      [:TEMPLATE, "hel"], [:TOPEN, "{{"], [:IDENTIFER, "lo"]
    ] }
    specify { scan('hel}lo').should == [[:TEMPLATE, "hel}lo"]] }
    specify { scan('hel}}lo').should == [[:TEMPLATE, "hel}}lo"]] }
    specify { scan('}}hello').should == [[:TEMPLATE, "}}hello"]] }
    specify { scan('hello{{').should == [[:TEMPLATE, "hello"], [:TOPEN, "{{"]] }
    specify { scan('2 + 3').should == [[:TEMPLATE, "2 + 3"]] }
    specify { scan('hel}}lo{{}}').should == [
      [:TEMPLATE, "hel}}lo"], [:TOPEN, "{{"], [:TCLOSE, "}}"]
    ] }
    specify { scan('hel}}lo{{').should == [[:TEMPLATE, "hel}}lo"], [:TOPEN, "{{"]] }
    specify { scan('hel}}lo{{ !empty').should == [
      [:TEMPLATE, "hel}}lo"], [:TOPEN, "{{"], [:NOT, "!"], [:IDENTIFER, "empty"]
    ] }
    specify { scan(' {{ }} ').should == [
      [:TEMPLATE, " "], [:TOPEN, "{{"], [:TCLOSE, "}}"], [:TEMPLATE, " "]
    ] }
    specify { scan('2 + 3 {{ 2 || 3 }} hello').should == [
      [:TEMPLATE, "2 + 3 "], [:TOPEN, "{{"], [:INTEGER, 2],
      [:OR, "||"], [:INTEGER, 3], [:TCLOSE, "}}"], [:TEMPLATE, " hello"]
    ] }

    context 'tag types' do
      specify { scan('{{hello}}').should == [
        [:TOPEN, "{{"], [:IDENTIFER, "hello"], [:TCLOSE, "}}"]
      ] }
      specify { scan('{{! hello}}').should == [
        [:TOPEN, "{{!"], [:IDENTIFER, "hello"], [:TCLOSE, "}}"]
      ] }
      specify { scan('{{ !hello}}').should == [
        [:TOPEN, "{{"], [:NOT, "!"], [:IDENTIFER, "hello"], [:TCLOSE, "}}"]
      ] }
      specify { scan('{{/ hello}}').should == [
        [:TOPEN, "{{"], [:DIVIDE, "/"], [:IDENTIFER, "hello"], [:TCLOSE, "}}"]
      ] }
      specify { scan('{{ /hello}}').should == [
        [:TOPEN, "{{"], [:DIVIDE, "/"], [:IDENTIFER, "hello"], [:TCLOSE, "}}"]
      ] }
    end
  end

  context 'template comments' do
    specify { scan('{{#').should == [[:COMMENT, "{{#"]] }
    specify { scan('{{# }}').should == [[:COMMENT, "{{# }}"]] }
    specify { scan('{{##}}').should == [[:COMMENT, "{{##}}"]] }
    specify { scan('{{###}}').should == [[:COMMENT, "{{###}}"]] }
    specify { scan('{{# {{# blabla').should == [[:COMMENT, "{{# {{# blabla"]] }
    specify { scan('{{# {{# }} blabla').should == [[:COMMENT, "{{# {{# }} blabla"]] }
    specify { scan('{{# {{ #}} blabla').should == [[:COMMENT, "{{# {{ #}}"], [:TEMPLATE, " blabla"]] }
    specify { scan('{# {{}}{{# {{# blabla').should == [[:TEMPLATE, "{# "], [:TOPEN, "{{"], [:TCLOSE, "}}"],
      [:COMMENT, "{{# {{# blabla"]] }
    specify { scan('{{ } {{# blabla').should == [[:TOPEN, "{{"], [:HCLOSE, "}"], [:HOPEN, "{"],
      [:HOPEN, "{"], [:COMMENT, "# blabla"]] }
  end
end
