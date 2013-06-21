# encoding: UTF-8
require 'spec_helper'

describe Hotcell::Parser do
  def method_missing method, *args, &block
    klass = Hotcell::Calculator::HANDLERS[method] ?
      Hotcell::Calculator : Hotcell::Node

    instance = Hotcell::Assigner.new *args if method == :ASSIGN
    instance = Hotcell::Summoner.new *args if method == :METHOD
    klass = Hotcell::Arrayer if [:ARRAY, :PAIR].include?(method)
    klass = Hotcell::Hasher if method == :HASH
    klass = Hotcell::Sequencer if method == :SEQUENCE

    klass = Hotcell::Tag if method == :TAG
    instance = Hotcell::Command.new *args if method == :COMMAND
    instance = Hotcell::Block.new *args if method == :BLOCK
    klass = Hotcell::Joiner if method == :JOINER

    instance || klass.new(method, *args)
  end

  def parse *args
    described_class.new(*args).parse
  end

  context 'template' do
    specify { parse('').should be_equal_node_to JOINER() }
    specify { parse(' ').should be_equal_node_to JOINER(' ') }
    specify { parse('{{ }}').should be_equal_node_to JOINER(TAG(mode: :normal)) }
    specify { parse('hello {{ }}').should be_equal_node_to JOINER('hello ', TAG(mode: :normal)) }
    specify { parse('{{ }}hello').should be_equal_node_to JOINER(TAG(mode: :normal), 'hello') }
    specify { parse('hello{{ }} hello').should be_equal_node_to JOINER('hello', TAG(mode: :normal), ' hello') }
    specify { parse('hello {{ hello(\'world\') }} hello').should be_equal_node_to JOINER(
      'hello ', TAG(METHOD(nil, 'hello', 'world'), mode: :normal), ' hello'
    ) }
    specify { parse('hello {{ hello(\'world\') }} hello {{! a = 5; }} {}').should be_equal_node_to JOINER(
      'hello ', TAG(METHOD(nil, 'hello', 'world'), mode: :normal),
      ' hello ', TAG(ASSIGN('a', 5), mode: :silence), ' {}'
    ) }
    specify { parse('{{ hello(\'world\') }} hello {{! a = 5; }} {}').should be_equal_node_to JOINER(
      TAG(METHOD(nil, 'hello', 'world'), mode: :normal),
      ' hello ', TAG(ASSIGN('a', 5), mode: :silence), ' {}'
    ) }
    specify { parse('{{ hello(\'world\') }} hello {{! a = 5; }}').should be_equal_node_to JOINER(
      TAG(METHOD(nil, 'hello', 'world'), mode: :normal),
      ' hello ', TAG(ASSIGN('a', 5), mode: :silence)
    ) }
  end

  context 'multiline' do
    specify { parse(<<-TPL
      {{
        hello;
        42
        [1, 2, 3];

        ;


        "hello"; {}
        (/regexp/; 43)

        foo = (3; 5)
        bar = 3; 5
      }}
    TPL
    ).should be_equal_node_to JOINER('      ', TAG(
      METHOD(nil, 'hello'),
      42,
      ARRAY(1, 2, 3),
      'hello',
      HASH(),
      SEQUENCE(/regexp/, 43),
      ASSIGN('foo', SEQUENCE(3, 5)),
      ASSIGN('bar', 3),
      5,
    mode: :normal), "\n") }
    specify { parse(<<-TPL
      {{
        foo(
        )
        hello(
          7,
          8
        )
        !
        true
        [
        ]
        2 +
        foo
        46 -
        moo
        46
        - moo
        2 **
        bar
        false ||
        nil
        baz >=
        5; foo =
        10
        {
        }
        [
          42, 43,
          44
        ]
        {
          foo: 'hello',
          bar:
            'world'
        }
      }}
    TPL
    ).should be_equal_node_to JOINER('      ', TAG(
      METHOD(nil, 'foo'),
      METHOD(nil, 'hello', 7, 8),
      false,
      ARRAY(),
      PLUS(2, METHOD(nil, 'foo')),
      MINUS(46, METHOD(nil, 'moo')),
      46,
      UMINUS(METHOD(nil, 'moo')),
      POWER(2, METHOD(nil, 'bar')),
      nil,
      GTE(METHOD(nil, 'baz'), 5),
      ASSIGN('foo', 10),
      HASH(),
      ARRAY(42, 43, 44),
      HASH(PAIR('foo', 'hello'), PAIR('bar', 'world')),
    mode: :normal), "\n") }
  end

  context 'expressions' do
    specify { parse('{{ 2 + hello }}').should be_equal_node_to JOINER(TAG(PLUS(2, METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ --2 }}').should be_equal_node_to JOINER(TAG(2, mode: :normal)) }
    specify { parse('{{ --hello }}').should be_equal_node_to JOINER(TAG(UMINUS(UMINUS(METHOD(nil, 'hello'))), mode: :normal)) }
    specify { parse('{{ \'hello\' + \'world\' }}').should be_equal_node_to JOINER(TAG('helloworld', mode: :normal)) }
    specify { parse('{{ 2 - hello }}').should be_equal_node_to JOINER(TAG(MINUS(2, METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ 2 * hello }}').should be_equal_node_to JOINER(TAG(MULTIPLY(2, METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ 2 / hello }}').should be_equal_node_to JOINER(TAG(DIVIDE(2, METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ 2 % hello }}').should be_equal_node_to JOINER(TAG(MODULO(2, METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ 2 ** hello }}').should be_equal_node_to JOINER(TAG(POWER(2, METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ -hello }}').should be_equal_node_to JOINER(TAG(UMINUS(METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ +hello }}').should be_equal_node_to JOINER(TAG(UPLUS(METHOD(nil, 'hello')), mode: :normal)) }
    specify { parse('{{ -2 }}').should be_equal_node_to JOINER(TAG(-2, mode: :normal)) }
    specify { parse('{{ +2 }}').should be_equal_node_to JOINER(TAG(2, mode: :normal)) }
    specify { parse('{{ 2 + lol * 2 }}').should be_equal_node_to JOINER(TAG(PLUS(2, MULTIPLY(METHOD(nil, 'lol'), 2)), mode: :normal)) }
    specify { parse('{{ 2 + lol - 2 }}').should be_equal_node_to JOINER(TAG(MINUS(PLUS(2, METHOD(nil, 'lol')), 2), mode: :normal)) }
    specify { parse('{{ 2 ** foo * 2 }}').should be_equal_node_to JOINER(TAG(MULTIPLY(POWER(2, METHOD(nil, 'foo')), 2), mode: :normal)) }
    specify { parse('{{ 1 ** foo ** 3 }}').should be_equal_node_to JOINER(TAG(POWER(1, POWER(METHOD(nil, 'foo'), 3)), mode: :normal)) }
    specify { parse('{{ (2 + foo) * 2 }}').should be_equal_node_to JOINER(TAG(MULTIPLY(PLUS(2, METHOD(nil, 'foo')), 2), mode: :normal)) }
    specify { parse('{{ (nil) }}').should be_equal_node_to JOINER(TAG(nil, mode: :normal)) }
    specify { parse('{{ (3) }}').should be_equal_node_to JOINER(TAG(3, mode: :normal)) }
    specify { parse('{{ (\'hello\') }}').should be_equal_node_to JOINER(TAG('hello', mode: :normal)) }
    specify { parse('{{ () }}').should be_equal_node_to JOINER(TAG(nil, mode: :normal)) }

    specify { parse('{{ bar > 2 }}').should be_equal_node_to JOINER(TAG(GT(METHOD(nil, 'bar'), 2), mode: :normal)) }
    specify { parse('{{ 2 < bar }}').should be_equal_node_to JOINER(TAG(LT(2, METHOD(nil, 'bar')), mode: :normal)) }
    specify { parse('{{ 2 >= tru }}').should be_equal_node_to JOINER(TAG(GTE(2, METHOD(nil, 'tru')), mode: :normal)) }
    specify { parse('{{ some <= 2 }}').should be_equal_node_to JOINER(TAG(LTE(METHOD(nil, 'some'), 2), mode: :normal)) }
    specify { parse('{{ 2 && false }}').should be_equal_node_to JOINER(TAG(false, mode: :normal)) }
    specify { parse('{{ null || 2 }}').should be_equal_node_to JOINER(TAG(2, mode: :normal)) }
    specify { parse('{{ 2 > bar < 2 }}').should be_equal_node_to JOINER(TAG(LT(GT(2, METHOD(nil, 'bar')), 2), mode: :normal)) }
    specify { parse('{{ 2 || bar && 2 }}').should be_equal_node_to JOINER(TAG(OR(2, AND(METHOD(nil, 'bar'), 2)), mode: :normal)) }
    specify { parse('{{ 2 && foo || 2 }}').should be_equal_node_to JOINER(TAG(OR(AND(2, METHOD(nil, 'foo')), 2), mode: :normal)) }
    specify { parse('{{ !2 && moo }}').should be_equal_node_to JOINER(TAG(AND(false, METHOD(nil, 'moo')), mode: :normal)) }
    specify { parse('{{ !(2 && moo) }}').should be_equal_node_to JOINER(TAG(NOT(AND(2, METHOD(nil, 'moo'))), mode: :normal)) }

    specify { parse('{{ hello = bzz + 2 }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', PLUS(METHOD(nil, 'bzz'), 2)), mode: :normal)) }
    specify { parse('{{ hello = 2 ** bar }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', POWER(2, METHOD(nil, 'bar'))), mode: :normal)) }
    specify { parse('{{ hello = 2 == 2 }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', true), mode: :normal)) }
    specify { parse('{{ hello = 2 && var }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', AND(2, METHOD(nil, 'var'))), mode: :normal)) }
    specify { parse('{{ hello = world() }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', METHOD(nil, 'world')), mode: :normal)) }
    specify { parse('{{ !hello = 2 >= 2 }}').should be_equal_node_to JOINER(TAG(NOT(ASSIGN('hello', true)), mode: :normal)) }

    specify { parse('{{ !foo ** 2 + 3 }}').should be_equal_node_to JOINER(TAG(PLUS(POWER(NOT(METHOD(nil, 'foo')), 2), 3), mode: :normal)) }
    specify { parse('{{ -bla ** 2 }}').should be_equal_node_to JOINER(TAG(UMINUS(POWER(METHOD(nil, 'bla'), 2)), mode: :normal)) }
    specify { parse('{{ -2 % bla }}').should be_equal_node_to JOINER(TAG(MODULO(-2, METHOD(nil, 'bla')), mode: :normal)) }
    specify { parse('{{ -hello ** 2 }}').should be_equal_node_to JOINER(TAG(UMINUS(POWER(METHOD(nil, 'hello'), 2)), mode: :normal)) }
    specify { parse('{{ -hello * 2 }}').should be_equal_node_to JOINER(TAG(MULTIPLY(UMINUS(METHOD(nil, 'hello')), 2), mode: :normal)) }
    specify { parse('{{ haha + 2 == 2 * 2 }}').should be_equal_node_to JOINER(TAG(EQUAL(PLUS(METHOD(nil, 'haha'), 2), 4), mode: :normal)) }
    specify { parse('{{ 2 * foo != 2 && bar }}').should be_equal_node_to JOINER(TAG(AND(INEQUAL(MULTIPLY(2, METHOD(nil, 'foo')), 2), METHOD(nil, 'bar')), mode: :normal)) }

    context 'method call' do
      specify { parse('{{ foo.bar.baz }}').should be_equal_node_to JOINER(TAG(
        METHOD(METHOD(METHOD(nil, 'foo'), 'bar'), 'baz'),
      mode: :normal)) }
      specify { parse('{{ foo(\'hello\').bar[2].baz(-42) }}').should be_equal_node_to JOINER(TAG(
        METHOD(
          METHOD(
            METHOD(
              METHOD(
                nil, 'foo', 'hello'
              ), 'bar'
            ), 'manipulator_brackets', 2
          ), 'baz', -42
        ),
      mode: :normal)) }
    end
  end

  context 'arrays' do
    specify { parse('{{ [] }}').should be_equal_node_to JOINER(TAG(ARRAY(), mode: :normal)) }
    specify { parse('{{ [ 2 ] }}').should be_equal_node_to JOINER(TAG(ARRAY(2), mode: :normal)) }
    specify { parse('{{ [ 2, 3 ] }}').should be_equal_node_to JOINER(TAG(ARRAY(2, 3), mode: :normal)) }
    specify { parse('{{ [2, 3][42] }}').should be_equal_node_to JOINER(TAG(METHOD(ARRAY(2, 3), 'manipulator_brackets', 42), mode: :normal)) }
    specify { parse('{{ [2 + foo, (2 * bar)] }}').should be_equal_node_to JOINER(TAG(ARRAY(PLUS(2, METHOD(nil, 'foo')), MULTIPLY(2, METHOD(nil, 'bar'))), mode: :normal)) }
    specify { parse('{{ [[2, 3], 42] }}').should be_equal_node_to JOINER(TAG(ARRAY(ARRAY(2, 3), 42), mode: :normal)) }
  end

  context 'hashes' do
    specify { parse('{{ {} }}').should be_equal_node_to JOINER(TAG(HASH(), mode: :normal)) }
    specify { parse('{{ { hello: \'world\' } }}').should be_equal_node_to(
      JOINER(TAG(HASH(PAIR('hello', 'world')), mode: :normal))
    ) }
    specify { parse('{{ {hello: \'world\'}[\'hello\'] }}').should be_equal_node_to(
      JOINER(TAG(METHOD(HASH(PAIR('hello', 'world')), 'manipulator_brackets', 'hello'), mode: :normal))
    ) }
    specify { parse('{{ { hello: 3, world: 6 * foo } }}').should be_equal_node_to(
      JOINER(TAG(HASH(
        PAIR('hello', 3),
        PAIR('world', MULTIPLY(6, METHOD(nil, 'foo')))
      ), mode: :normal))
    ) }
  end

  context '[]' do
    specify { parse('{{ hello[3] }}').should be_equal_node_to JOINER(TAG(METHOD(METHOD(nil, 'hello'), 'manipulator_brackets', 3), mode: :normal)) }
    specify { parse('{{ \'boom\'[3] }}').should be_equal_node_to JOINER(TAG(METHOD('boom', 'manipulator_brackets', 3), mode: :normal)) }
    specify { parse('{{ 7[3] }}').should be_equal_node_to JOINER(TAG(METHOD(7, 'manipulator_brackets', 3), mode: :normal)) }
    specify { parse('{{ 3 + 5[7] }}').should be_equal_node_to JOINER(TAG(PLUS(3, METHOD(5, 'manipulator_brackets', 7)), mode: :normal)) }
    specify { parse('{{ (3 + 5)[7] }}').should be_equal_node_to JOINER(TAG(METHOD(8, 'manipulator_brackets', 7), mode: :normal)) }
  end

  context 'function arguments' do
    specify { parse('{{ hello() }}').should be_equal_node_to JOINER(TAG(METHOD(nil, 'hello'), mode: :normal)) }
    specify { parse('{{ hello(2 * foo) }}').should be_equal_node_to(
      JOINER(TAG(METHOD(nil, 'hello', MULTIPLY(2, METHOD(nil, 'foo'))), mode: :normal))
    ) }
    specify { parse('{{ hello([2 * car]) }}').should be_equal_node_to(
      JOINER(TAG(METHOD(nil, 'hello', ARRAY(MULTIPLY(2, METHOD(nil, 'car')))), mode: :normal))
    ) }
    specify { parse('{{ hello({hello: \'world\'}) }}').should be_equal_node_to(
      JOINER(TAG(METHOD(nil, 'hello', HASH(PAIR('hello', 'world'))), mode: :normal))
    ) }
    specify { parse('{{ hello(hello: \'world\') }}').should be_equal_node_to(
      JOINER(TAG(METHOD(nil, 'hello', HASH(PAIR('hello', 'world'))), mode: :normal))
    ) }
    specify { parse('{{ hello(2 * foo, \'bla\', {hello: \'world\'}) }}').should be_equal_node_to(
      JOINER(TAG(METHOD(nil, 'hello',
        MULTIPLY(2, METHOD(nil, 'foo')),
        'bla',
        HASH(PAIR('hello', 'world'))
      ), mode: :normal))
    ) }
    specify { parse('{{ hello(moo * 3, \'bla\', hello: \'world\') }}').should be_equal_node_to(
      JOINER(TAG(METHOD(nil, 'hello',
        MULTIPLY(METHOD(nil, 'moo'), 3),
        'bla',
        HASH(PAIR('hello', 'world'))
      ), mode: :normal))
    ) }
  end

  context 'sequences' do
    specify { parse('{{ 42; }}').should be_equal_node_to JOINER(TAG(42, mode: :normal)) }
    specify { parse('{{ (42) }}').should be_equal_node_to JOINER(TAG(42, mode: :normal)) }
    specify { parse('{{ ((42)) }}').should be_equal_node_to JOINER(TAG(42, mode: :normal)) }
    specify { parse('{{ ;;;; }}').should be_equal_node_to JOINER(TAG(mode: :normal)) }
    specify { parse('{{ ;;;;;;; 42 }}').should be_equal_node_to JOINER(TAG(42, mode: :normal)) }
    specify { parse('{{ ;;;111;;;; 42 }}').should be_equal_node_to JOINER(TAG(111, 42, mode: :normal)) }
    specify { parse("{{ 42 ;;;;\n;;; }}").should be_equal_node_to JOINER(TAG(42, mode: :normal)) }
    specify { parse('{{ 42 ;;;;;;1 }}').should be_equal_node_to JOINER(TAG(42, 1, mode: :normal)) }
    specify { parse('{{ 42; 43 }}').should be_equal_node_to JOINER(TAG(42, 43, mode: :normal)) }
    specify { parse('{{ ; 42; 43 }}').should be_equal_node_to JOINER(TAG(42, 43, mode: :normal)) }
    specify { parse('{{ 42; 43; 44 }}').should be_equal_node_to JOINER(TAG(42, 43, 44, mode: :normal)) }
    specify { parse('{{ 42; \'hello\'; 44; }}').should be_equal_node_to JOINER(TAG(42, 'hello', 44, mode: :normal)) }
    specify { parse('{{ (42; \'hello\'); 44; }}').should be_equal_node_to JOINER(TAG(SEQUENCE(42, 'hello'), 44, mode: :normal)) }
    specify { parse('{{ 42; (\'hello\'; 44;) }}').should be_equal_node_to JOINER(TAG(42, SEQUENCE('hello', 44), mode: :normal)) }
    specify { parse('{{ hello(42, (43; 44), 45) }}').should be_equal_node_to JOINER(TAG(METHOD(nil, 'hello', 42, SEQUENCE(43, 44), 45), mode: :normal)) }
    specify { parse('{{ hello(42, ((43; 44)), 45) }}').should be_equal_node_to JOINER(TAG(METHOD(nil, 'hello', 42, SEQUENCE(43, 44), 45), mode: :normal)) }
    specify { parse('{{ hello((42)) }}').should be_equal_node_to JOINER(TAG(METHOD(nil, 'hello', 42), mode: :normal)) }
  end

  context 'comments' do
    specify { parse('hello # world').should be_equal_node_to JOINER('hello # world') }
    specify { parse('hello {{# world').should be_equal_node_to JOINER('hello ') }
    specify { parse('hello {{# world #}} friend').should be_equal_node_to JOINER('hello ', ' friend') }
    specify { parse('hello {{!# world #}}').should be_equal_node_to JOINER('hello ', TAG(mode: :silence)) }
    specify { parse('hello {{ # world}}').should be_equal_node_to JOINER('hello ', TAG(mode: :normal)) }
    specify { parse('hello {{ # world; foo}}').should be_equal_node_to JOINER('hello ', TAG(mode: :normal)) }
    specify { parse("hello {{ # world\n foo}}").should be_equal_node_to JOINER('hello ', TAG(METHOD(nil, 'foo'), mode: :normal)) }
    specify { parse("hello {{ world# foo}}").should be_equal_node_to JOINER('hello ', TAG(METHOD(nil, 'world'), mode: :normal)) }
  end

  context 'commands' do
    specify { parse("{{ include 'some/partial' }}",
      commands: [:include, :snippet]).should be_equal_node_to JOINER(
        TAG(COMMAND('include', 'some/partial'), mode: :normal)
      ) }
    specify { parse("{{ include }}",
      commands: [:include, :snippet]).should be_equal_node_to JOINER(
        TAG(COMMAND('include'), mode: :normal)
      ) }
    specify { parse("{{! include 'some/partial' }}\n{{ snippet 'sidebar' }}",
      commands: [:include, :snippet]).should be_equal_node_to JOINER(
        TAG(COMMAND('include', 'some/partial'), mode: :silence),
        "\n",
        TAG(COMMAND('snippet', 'sidebar'), mode: :normal),
      ) }
    specify { parse("{{! variable = include }}",
      commands: [:include, :snippet]).should be_equal_node_to JOINER(
        TAG(ASSIGN('variable', COMMAND('include')), mode: :silence)
      ) }
    specify { parse("{{ variable = include 'some/partial' }}",
      commands: [:include, :snippet]).should be_equal_node_to JOINER(
        TAG(ASSIGN('variable', COMMAND('include', 'some/partial')), mode: :normal)
      ) }
  end

  context 'blocks' do
    specify { parse("{{ scoped }}{{ end scoped }}",
      blocks: [:scoped, :each]).should be_equal_node_to JOINER(
        TAG(BLOCK('scoped'), mode: :normal)
      ) }
    specify { parse("{{ scoped var: 'hello' }}{{ endscoped }}",
      blocks: [:scoped, :each]).should be_equal_node_to JOINER(
        TAG(BLOCK('scoped', HASH(PAIR('var', 'hello'))), mode: :normal)
      ) }
    specify { parse("<article>\n{{ each post, in: posts }}\n<h1>{{ post.title }}</h1>\n{{ end each }}\n</article>",
      blocks: [:scoped, :each]).should be_equal_node_to JOINER(
        "<article>\n",
        TAG(BLOCK('each',
          METHOD(nil, 'post'),
          HASH(PAIR('in', METHOD(nil, 'posts'))),
          subnodes: [JOINER(
            "\n<h1>",
            TAG(METHOD(METHOD(nil, 'post'), 'title'), mode: :normal),
            "</h1>\n"
          )]
        ), mode: :normal),
        "\n</article>"
      ) }
    specify { parse("{{! iter = each post, in: posts }}\n<h1>{{ post.title }}</h1>\n{{ end each }}",
      blocks: [:scoped, :each]).should be_equal_node_to JOINER(
        TAG(ASSIGN('iter', BLOCK('each',
          METHOD(nil, 'post'),
          HASH(PAIR('in', METHOD(nil, 'posts'))),
          subnodes: [JOINER(
            "\n<h1>",
            TAG(METHOD(METHOD(nil, 'post'), 'title'), mode: :normal),
            "</h1>\n"
          )]
        )), mode: :silence),
      ) }
    specify { parse("{{ capture = scoped }} hello {{ each post, in: posts }} {{ loop }} {{ end each }}{{ endscoped }}",
      blocks: [:scoped, :each]).should be_equal_node_to JOINER(
        TAG(ASSIGN('capture', BLOCK('scoped',
          subnodes: [JOINER(
            ' hello ',
            TAG(BLOCK('each',
              METHOD(nil, 'post'),
              HASH(PAIR('in', METHOD(nil, 'posts'))),
              subnodes: [JOINER(
                ' ',
                TAG(METHOD(nil, 'loop'), mode: :normal),
                ' '
              )]
            ), mode: :normal)
          )]
        )), mode: :normal)
      ) }
  end

  context 'errors' do
    let(:error) { Hotcell::UnexpectedLexem }

    specify { expect { parse("{{ var = 3 * 5; hello(, 3) }}") }.to raise_error error, 'Unexpected COMMA `,` at 1:23' }
  end
end
