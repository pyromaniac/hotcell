# encoding: UTF-8
require 'spec_helper'

describe Hotcell::Parser do
  def method_missing method, *args, &block
    klass = Hotcell::Expression::HANDLERS[method] ?
      Hotcell::Expression : Hotcell::Node

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
      'hello ', TAG(METHOD('hello', nil, 'world'), mode: :normal), ' hello'
    ) }
    specify { parse('hello {{ hello(\'world\') }} hello {{! a = 5; }} {}').should be_equal_node_to JOINER(
      'hello ', TAG(METHOD('hello', nil, 'world'), mode: :normal),
      ' hello ', TAG(ASSIGN('a', 5), mode: :silence), ' {}'
    ) }
    specify { parse('{{ hello(\'world\') }} hello {{! a = 5; }} {}').should be_equal_node_to JOINER(
      TAG(METHOD('hello', nil, 'world'), mode: :normal),
      ' hello ', TAG(ASSIGN('a', 5), mode: :silence), ' {}'
    ) }
    specify { parse('{{ hello(\'world\') }} hello {{! a = 5; }}').should be_equal_node_to JOINER(
      TAG(METHOD('hello', nil, 'world'), mode: :normal),
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
      METHOD('hello'),
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
      METHOD('foo'),
      METHOD('hello', nil, 7, 8),
      false,
      ARRAY(),
      PLUS(2, METHOD('foo')),
      MINUS(46, METHOD('moo')),
      46,
      UMINUS(METHOD('moo')),
      POWER(2, METHOD('bar')),
      nil,
      GTE(METHOD('baz'), 5),
      ASSIGN('foo', 10),
      HASH(),
      ARRAY(42, 43, 44),
      HASH(PAIR('foo', 'hello'), PAIR('bar', 'world')),
    mode: :normal), "\n") }
  end

  context 'expressions' do
    specify { parse('{{ 2 + hello }}').should be_equal_node_to JOINER(TAG(PLUS(2, METHOD('hello')), mode: :normal)) }
    specify { parse('{{ --2 }}').should be_equal_node_to JOINER(TAG(2, mode: :normal)) }
    specify { parse('{{ --hello }}').should be_equal_node_to JOINER(TAG(UMINUS(UMINUS(METHOD('hello'))), mode: :normal)) }
    specify { parse('{{ \'hello\' + \'world\' }}').should be_equal_node_to JOINER(TAG('helloworld', mode: :normal)) }
    specify { parse('{{ 2 - hello }}').should be_equal_node_to JOINER(TAG(MINUS(2, METHOD('hello')), mode: :normal)) }
    specify { parse('{{ 2 * hello }}').should be_equal_node_to JOINER(TAG(MULTIPLY(2, METHOD('hello')), mode: :normal)) }
    specify { parse('{{ 2 / hello }}').should be_equal_node_to JOINER(TAG(DIVIDE(2, METHOD('hello')), mode: :normal)) }
    specify { parse('{{ 2 % hello }}').should be_equal_node_to JOINER(TAG(MODULO(2, METHOD('hello')), mode: :normal)) }
    specify { parse('{{ 2 ** hello }}').should be_equal_node_to JOINER(TAG(POWER(2, METHOD('hello')), mode: :normal)) }
    specify { parse('{{ -hello }}').should be_equal_node_to JOINER(TAG(UMINUS(METHOD('hello')), mode: :normal)) }
    specify { parse('{{ +hello }}').should be_equal_node_to JOINER(TAG(UPLUS(METHOD('hello')), mode: :normal)) }
    specify { parse('{{ -2 }}').should be_equal_node_to JOINER(TAG(-2, mode: :normal)) }
    specify { parse('{{ +2 }}').should be_equal_node_to JOINER(TAG(2, mode: :normal)) }
    specify { parse('{{ 2 + lol * 2 }}').should be_equal_node_to JOINER(TAG(PLUS(2, MULTIPLY(METHOD('lol'), 2)), mode: :normal)) }
    specify { parse('{{ 2 + lol - 2 }}').should be_equal_node_to JOINER(TAG(MINUS(PLUS(2, METHOD('lol')), 2), mode: :normal)) }
    specify { parse('{{ 2 ** foo * 2 }}').should be_equal_node_to JOINER(TAG(MULTIPLY(POWER(2, METHOD('foo')), 2), mode: :normal)) }
    specify { parse('{{ 1 ** foo ** 3 }}').should be_equal_node_to JOINER(TAG(POWER(1, POWER(METHOD('foo'), 3)), mode: :normal)) }
    specify { parse('{{ (2 + foo) * 2 }}').should be_equal_node_to JOINER(TAG(MULTIPLY(PLUS(2, METHOD('foo')), 2), mode: :normal)) }
    specify { parse('{{ (nil) }}').should be_equal_node_to JOINER(TAG(nil, mode: :normal)) }
    specify { parse('{{ (3) }}').should be_equal_node_to JOINER(TAG(3, mode: :normal)) }
    specify { parse('{{ (\'hello\') }}').should be_equal_node_to JOINER(TAG('hello', mode: :normal)) }
    specify { parse('{{ () }}').should be_equal_node_to JOINER(TAG(nil, mode: :normal)) }

    specify { parse('{{ \'a\'..\'z\' }}').should be_equal_node_to JOINER(TAG('a'..'z', mode: :normal)) }
    specify { parse('{{ 0..10 }}').should be_equal_node_to JOINER(TAG(0..10, mode: :normal)) }
    specify { parse('{{ 0...10 }}').should be_equal_node_to JOINER(TAG(0...10, mode: :normal)) }
    specify { parse('{{ 3 + 0..10 + 5 }}').should be_equal_node_to JOINER(TAG(3..15, mode: :normal)) }
    specify { parse('{{ 3 + (0..var) + 5 }}').should be_equal_node_to JOINER(TAG(PLUS(PLUS(3, RANGE(0, METHOD('var'))), 5), mode: :normal)) }

    specify { parse('{{ bar > 2 }}').should be_equal_node_to JOINER(TAG(GT(METHOD('bar'), 2), mode: :normal)) }
    specify { parse('{{ 2 < bar }}').should be_equal_node_to JOINER(TAG(LT(2, METHOD('bar')), mode: :normal)) }
    specify { parse('{{ 2 >= tru }}').should be_equal_node_to JOINER(TAG(GTE(2, METHOD('tru')), mode: :normal)) }
    specify { parse('{{ some <= 2 }}').should be_equal_node_to JOINER(TAG(LTE(METHOD('some'), 2), mode: :normal)) }
    specify { parse('{{ 2 && false }}').should be_equal_node_to JOINER(TAG(false, mode: :normal)) }
    specify { parse('{{ null || 2 }}').should be_equal_node_to JOINER(TAG(2, mode: :normal)) }
    specify { parse('{{ 2 > bar < 2 }}').should be_equal_node_to JOINER(TAG(LT(GT(2, METHOD('bar')), 2), mode: :normal)) }
    specify { parse('{{ 2 || bar && 2 }}').should be_equal_node_to JOINER(TAG(OR(2, AND(METHOD('bar'), 2)), mode: :normal)) }
    specify { parse('{{ 2 && foo || 2 }}').should be_equal_node_to JOINER(TAG(OR(AND(2, METHOD('foo')), 2), mode: :normal)) }
    specify { parse('{{ !2 && moo }}').should be_equal_node_to JOINER(TAG(AND(false, METHOD('moo')), mode: :normal)) }
    specify { parse('{{ !(2 && moo) }}').should be_equal_node_to JOINER(TAG(NOT(AND(2, METHOD('moo'))), mode: :normal)) }

    specify { parse('{{ hello = bzz + 2 }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', PLUS(METHOD('bzz'), 2)), mode: :normal)) }
    specify { parse('{{ hello = 2 ** bar }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', POWER(2, METHOD('bar'))), mode: :normal)) }
    specify { parse('{{ hello = 2 == 2 }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', true), mode: :normal)) }
    specify { parse('{{ hello = 2 && var }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', AND(2, METHOD('var'))), mode: :normal)) }
    specify { parse('{{ hello = world() }}').should be_equal_node_to JOINER(TAG(ASSIGN('hello', METHOD('world')), mode: :normal)) }
    specify { parse('{{ !hello = 2 >= 2 }}').should be_equal_node_to JOINER(TAG(NOT(ASSIGN('hello', true)), mode: :normal)) }

    specify { parse('{{ !foo ** 2 + 3 }}').should be_equal_node_to JOINER(TAG(PLUS(POWER(NOT(METHOD('foo')), 2), 3), mode: :normal)) }
    specify { parse('{{ -bla ** 2 }}').should be_equal_node_to JOINER(TAG(UMINUS(POWER(METHOD('bla'), 2)), mode: :normal)) }
    specify { parse('{{ -2 % bla }}').should be_equal_node_to JOINER(TAG(MODULO(-2, METHOD('bla')), mode: :normal)) }
    specify { parse('{{ -hello ** 2 }}').should be_equal_node_to JOINER(TAG(UMINUS(POWER(METHOD('hello'), 2)), mode: :normal)) }
    specify { parse('{{ -hello * 2 }}').should be_equal_node_to JOINER(TAG(MULTIPLY(UMINUS(METHOD('hello')), 2), mode: :normal)) }
    specify { parse('{{ haha + 2 == 2 * 2 }}').should be_equal_node_to JOINER(TAG(EQUAL(PLUS(METHOD('haha'), 2), 4), mode: :normal)) }
    specify { parse('{{ 2 * foo != 2 && bar }}').should be_equal_node_to JOINER(TAG(AND(INEQUAL(MULTIPLY(2, METHOD('foo')), 2), METHOD('bar')), mode: :normal)) }

    context 'method call' do
      specify { parse('{{ foo.bar.baz }}').should be_equal_node_to JOINER(TAG(
        METHOD('baz', METHOD('bar', METHOD('foo'))),
      mode: :normal)) }
      specify { parse('{{ -bar.baz }}').should be_equal_node_to JOINER(TAG(
        UMINUS(METHOD('baz', METHOD('bar'))),
      mode: :normal)) }
      specify { parse('{{ -42.baz }}').should be_equal_node_to JOINER(TAG(
        METHOD('baz', -42),
      mode: :normal)) }
      specify { parse('{{ - 42.baz }}').should be_equal_node_to JOINER(TAG(
        UMINUS(METHOD('baz', 42)),
      mode: :normal)) }
      specify { parse('{{ -42.42.baz }}').should be_equal_node_to JOINER(TAG(
        METHOD('baz', -42.42),
      mode: :normal)) }
      specify { parse('{{ foo(\'hello\').bar[2].baz(-42) }}').should be_equal_node_to JOINER(TAG(
        METHOD('baz',
          METHOD('[]',
            METHOD('bar',
              METHOD('foo', nil, 'hello')
            ), 2
          ), -42
        ),
      mode: :normal)) }
    end
  end

  context 'ternary operator' do
    specify { parse('{{ true ? 42 : 43 }}').should be_equal_node_to JOINER(TAG(42, mode: :normal)) }
    specify { parse('{{ false ? 42 : 43 }}').should be_equal_node_to JOINER(TAG(43, mode: :normal)) }
    specify { parse('{{ cond ? branch1 : branch2 }}').should be_equal_node_to JOINER(
      TAG(TERNARY(METHOD('cond'), METHOD('branch1'), METHOD('branch2')), mode: :normal)
    ) }
    specify { parse('{{ cond1 ? branch1 : cond2 ? branch2 : branch3 }}').should be_equal_node_to JOINER(
      TAG(TERNARY(
        METHOD('cond1'), METHOD('branch1'),
        TERNARY(METHOD('cond2'), METHOD('branch2'), METHOD('branch3'))
      ), mode: :normal)
    ) }
    specify { parse('{{ (cond1 ? branch1 : cond2) ? branch2 : branch3 }}').should be_equal_node_to JOINER(
      TAG(TERNARY(
        TERNARY(METHOD('cond1'), METHOD('branch1'), METHOD('cond2')),
        METHOD('branch2'), METHOD('branch3')
      ), mode: :normal)
    ) }
    specify { parse('{{ cond1 ? cond2 ? branch1 : branch2 : branch3 }}').should be_equal_node_to JOINER(
      TAG(TERNARY(
        METHOD('cond1'),
        TERNARY(METHOD('cond2'), METHOD('branch1'), METHOD('branch2')),
        METHOD('branch3')
      ), mode: :normal)
    ) }
    specify { parse('{{ res = cond ? branch1 + 3 : branch2 && true }}').should be_equal_node_to JOINER(
      TAG(ASSIGN('res',
        TERNARY(METHOD('cond'), PLUS(METHOD('branch1'), 3), AND(METHOD('branch2'), true)
      )), mode: :normal)
    ) }
    specify { expect { parse('{{ (1 ? 2) : 3 }}') }.to raise_error Hotcell::UnexpectedLexem, "Unexpected PCLOSE `)` at 1:10"}
  end

  context 'interpolation' do
    specify { parse('{{ "hello" }}').should be_equal_node_to JOINER(TAG('hello', mode: :normal)) }
    specify { parse('{{ \'#{}\' }}').should be_equal_node_to JOINER(TAG('#{}', mode: :normal)) }
    specify { parse('{{ "#{}" }}').should be_equal_node_to JOINER(TAG('', mode: :normal)) }
    specify { parse('{{ "#{ 3 }" }}').should be_equal_node_to JOINER(TAG('3', mode: :normal)) }
    specify { parse('{{ "#{ var }" }}').should be_equal_node_to JOINER(TAG(DSTRING(METHOD('var')), mode: :normal)) }
    specify { parse('{{ "#{ var }world" }}').should be_equal_node_to JOINER(TAG(DSTRING(METHOD('var'), 'world'), mode: :normal)) }
    specify { parse('{{ "hello#{}" }}').should be_equal_node_to JOINER(TAG('hello', mode: :normal)) }
    specify { parse('{{ "hello#{}world" }}').should be_equal_node_to JOINER(TAG('helloworld', mode: :normal)) }
    specify { parse('{{ "hello#{ 6 * 7 }world" }}').should be_equal_node_to JOINER(TAG('hello42world', mode: :normal)) }
    specify { parse('{{ "hello#{ var = 6 * 7; var + 1 }world" }}').should be_equal_node_to JOINER(
      TAG(DSTRING('hello', SEQUENCE(ASSIGN('var', 42), PLUS(METHOD('var'), 1)),  'world'), mode: :normal)
    ) }
  end

  context 'arrays' do
    specify { parse('{{ [] }}').should be_equal_node_to JOINER(TAG(ARRAY(), mode: :normal)) }
    specify { parse('{{ [ 2 ] }}').should be_equal_node_to JOINER(TAG(ARRAY(2), mode: :normal)) }
    specify { parse('{{ [ 2, 3 ] }}').should be_equal_node_to JOINER(TAG(ARRAY(2, 3), mode: :normal)) }
    specify { parse('{{ [2, 3][42] }}').should be_equal_node_to JOINER(TAG(METHOD('[]', ARRAY(2, 3), 42), mode: :normal)) }
    specify { parse('{{ [2 + foo, (2 * bar)] }}').should be_equal_node_to JOINER(TAG(ARRAY(PLUS(2, METHOD('foo')), MULTIPLY(2, METHOD('bar'))), mode: :normal)) }
    specify { parse('{{ [[2, 3], 42] }}').should be_equal_node_to JOINER(TAG(ARRAY(ARRAY(2, 3), 42), mode: :normal)) }
  end

  context 'hashes' do
    specify { parse('{{ {} }}').should be_equal_node_to JOINER(TAG(HASH(), mode: :normal)) }
    specify { parse('{{ { hello: \'world\' } }}').should be_equal_node_to(
      JOINER(TAG(HASH(PAIR('hello', 'world')), mode: :normal))
    ) }
    specify { parse('{{ {hello: \'world\'}[\'hello\'] }}').should be_equal_node_to(
      JOINER(TAG(METHOD('[]', HASH(PAIR('hello', 'world')), 'hello'), mode: :normal))
    ) }
    specify { parse('{{ { hello: 3, world: 6 * foo } }}').should be_equal_node_to(
      JOINER(TAG(HASH(
        PAIR('hello', 3),
        PAIR('world', MULTIPLY(6, METHOD('foo')))
      ), mode: :normal))
    ) }
  end

  context '[]' do
    specify { parse('{{ hello[3] }}').should be_equal_node_to JOINER(TAG(METHOD('[]', METHOD('hello'), 3), mode: :normal)) }
    specify { parse('{{ \'boom\'[3] }}').should be_equal_node_to JOINER(TAG(METHOD('[]', 'boom', 3), mode: :normal)) }
    specify { parse('{{ 7[3] }}').should be_equal_node_to JOINER(TAG(METHOD('[]', 7, 3), mode: :normal)) }
    specify { parse('{{ 3 + 5[7] }}').should be_equal_node_to JOINER(TAG(PLUS(3, METHOD('[]', 5, 7)), mode: :normal)) }
    specify { parse('{{ (3 + 5)[7] }}').should be_equal_node_to JOINER(TAG(METHOD('[]', 8, 7), mode: :normal)) }
  end

  context 'function arguments' do
    specify { parse('{{ hello() }}').should be_equal_node_to JOINER(TAG(METHOD('hello'), mode: :normal)) }
    specify { parse('{{ hello(2 * foo) }}').should be_equal_node_to(
      JOINER(TAG(METHOD('hello', nil, MULTIPLY(2, METHOD('foo'))), mode: :normal))
    ) }
    specify { parse('{{ hello([2 * car]) }}').should be_equal_node_to(
      JOINER(TAG(METHOD('hello', nil, ARRAY(MULTIPLY(2, METHOD('car')))), mode: :normal))
    ) }
    specify { parse('{{ hello({hello: \'world\'}) }}').should be_equal_node_to(
      JOINER(TAG(METHOD('hello', nil, HASH(PAIR('hello', 'world'))), mode: :normal))
    ) }
    specify { parse('{{ hello(hello: \'world\') }}').should be_equal_node_to(
      JOINER(TAG(METHOD('hello', nil, HASH(PAIR('hello', 'world'))), mode: :normal))
    ) }
    specify { parse('{{ hello(2 * foo, \'bla\', {hello: \'world\'}) }}').should be_equal_node_to(
      JOINER(TAG(METHOD('hello', nil,
        MULTIPLY(2, METHOD('foo')),
        'bla',
        HASH(PAIR('hello', 'world'))
      ), mode: :normal))
    ) }
    specify { parse('{{ hello(moo * 3, \'bla\', hello: \'world\') }}').should be_equal_node_to(
      JOINER(TAG(METHOD('hello', nil,
        MULTIPLY(METHOD('moo'), 3),
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
    specify { parse('{{ hello(42, (43; 44), 45) }}').should be_equal_node_to JOINER(TAG(METHOD('hello', nil, 42, SEQUENCE(43, 44), 45), mode: :normal)) }
    specify { parse('{{ hello(42, ((43; 44)), 45) }}').should be_equal_node_to JOINER(TAG(METHOD('hello', nil, 42, SEQUENCE(43, 44), 45), mode: :normal)) }
    specify { parse('{{ hello((42)) }}').should be_equal_node_to JOINER(TAG(METHOD('hello', nil, 42), mode: :normal)) }
  end

  context 'comments' do
    specify { parse('hello # world').should be_equal_node_to JOINER('hello # world') }
    specify { parse('hello {{# world').should be_equal_node_to JOINER('hello ') }
    specify { parse('hello {{# world #}} friend').should be_equal_node_to JOINER('hello ', ' friend') }
    specify { parse('hello {{!# world #}}').should be_equal_node_to JOINER('hello ', TAG(mode: :silence)) }
    specify { parse('hello {{ # world}}').should be_equal_node_to JOINER('hello ', TAG(mode: :normal)) }
    specify { parse('hello {{ # world; foo}}').should be_equal_node_to JOINER('hello ', TAG(mode: :normal)) }
    specify { parse("hello {{ # world\n foo}}").should be_equal_node_to JOINER('hello ', TAG(METHOD('foo'), mode: :normal)) }
    specify { parse("hello {{ world# foo}}").should be_equal_node_to JOINER('hello ', TAG(METHOD('world'), mode: :normal)) }
  end

  context 'tag modes' do
    specify { parse('{{  }}').should be_equal_node_to JOINER(TAG(mode: :normal)) }
    specify { parse('{{!  }}').should be_equal_node_to JOINER(TAG(mode: :silence)) }
    specify { parse('{{^  }}').should be_equal_node_to JOINER(TAG(mode: :escape)) }
    specify { parse('{{e  }}').should be_equal_node_to JOINER(TAG(mode: :escape)) }
    specify { parse('{{~  }}').should be_equal_node_to JOINER(TAG(mode: :normal)) }
    specify { parse('{{r  }}').should be_equal_node_to JOINER(TAG(mode: :normal)) }

    context 'escape_tags' do
      specify { parse('{{  }}', escape_tags: true).should be_equal_node_to JOINER(TAG(mode: :escape)) }
    end

    context 'commands' do
      let(:snippet_command) { Class.new(Hotcell::Command) }
      let(:commands) { { snippet: snippet_command }.stringify_keys }

      specify { parse('{{ snippet }}', commands: commands).should be_equal_node_to JOINER(
        TAG(snippet_command.build('snippet'), mode: :normal)
      ) }
      specify { parse('{{! snippet }}', commands: commands).should be_equal_node_to JOINER(
        TAG(snippet_command.build('snippet'), mode: :silence)
      ) }
      specify { parse('{{^ snippet }}', commands: commands).should be_equal_node_to JOINER(
        TAG(snippet_command.build('snippet'), mode: :escape)
      ) }
      specify { parse('{{e snippet }}', commands: commands).should be_equal_node_to JOINER(
        TAG(snippet_command.build('snippet'), mode: :escape)
      ) }
      specify { parse('{{~ snippet }}', commands: commands).should be_equal_node_to JOINER(
        TAG(snippet_command.build('snippet'), mode: :normal)
      ) }
      specify { parse('{{r snippet }}', commands: commands).should be_equal_node_to JOINER(
        TAG(snippet_command.build('snippet'), mode: :normal)
      ) }

      context 'escape_tags' do
        specify { parse('{{ snippet }}',
          commands: commands, escape_tags: true
        ).should be_equal_node_to JOINER(
          TAG(snippet_command.build('snippet'), mode: :normal)
        ) }
      end
    end

    context 'blocks' do
      let(:cycle_block) { Class.new(Hotcell::Block) }
      let(:blocks) { { cycle: cycle_block }.stringify_keys }

      specify { parse('{{ cycle }}{{ end }}', blocks: blocks).should be_equal_node_to JOINER(
        TAG(cycle_block.build('cycle'), mode: :normal)
      ) }
      specify { parse('{{! cycle }}{{ end }}', blocks: blocks).should be_equal_node_to JOINER(
        TAG(cycle_block.build('cycle'), mode: :silence)
      ) }
      specify { parse('{{^ cycle }}{{ end }}', blocks: blocks).should be_equal_node_to JOINER(
        TAG(cycle_block.build('cycle'), mode: :escape)
      ) }
      specify { parse('{{e cycle }}{{ end }}', blocks: blocks).should be_equal_node_to JOINER(
        TAG(cycle_block.build('cycle'), mode: :escape)
      ) }
      specify { parse('{{~ cycle }}{{ end }}', blocks: blocks).should be_equal_node_to JOINER(
        TAG(cycle_block.build('cycle'), mode: :normal)
      ) }
      specify { parse('{{r cycle }}{{ end }}', blocks: blocks).should be_equal_node_to JOINER(
        TAG(cycle_block.build('cycle'), mode: :normal)
      ) }

      context 'escape_tags' do
        specify { parse('{{ cycle }}{{ end }}',
          blocks: blocks, escape_tags: true
        ).should be_equal_node_to JOINER(
          TAG(cycle_block.build('cycle'), mode: :normal)
        ) }
      end
    end
  end

  context 'commands' do
    let(:include_command) { Class.new(Hotcell::Command) }
    let(:snippet_command) { Class.new(Hotcell::Command) }
    let(:commands) do
      {
        include: include_command,
        snippet: snippet_command
      }.stringify_keys
    end

    specify { parse("{{ include 'some/partial' }}",
      commands: commands).should be_equal_node_to JOINER(
        TAG(include_command.build('include', 'some/partial'), mode: :normal)
      ) }
    specify { parse("{{ include }}",
      commands: commands).should be_equal_node_to JOINER(
        TAG(include_command.build('include'), mode: :normal)
      ) }
    specify { parse("{{! include 'some/partial' }}\n{{ snippet 'sidebar' }}",
      commands: commands).should be_equal_node_to JOINER(
        TAG(include_command.build('include', 'some/partial'), mode: :silence),
        "\n",
        TAG(snippet_command.build('snippet', 'sidebar'), mode: :normal),
      ) }
    specify { parse("{{! variable = include }}",
      commands: commands).should be_equal_node_to JOINER(
        TAG(ASSIGN('variable', include_command.build('include')), mode: :silence)
      ) }
    specify { parse("{{ variable = include 'some/partial' }}",
      commands: commands).should be_equal_node_to JOINER(
        TAG(ASSIGN('variable', include_command.build('include', 'some/partial')), mode: :normal)
      ) }
  end

  context 'blocks' do
    let(:scoped_block) { Class.new(Hotcell::Block) }
    let(:each_block) { Class.new(Hotcell::Block) }
    let(:blocks) do
      {
        scoped: scoped_block,
        each: each_block
      }.stringify_keys
    end

    specify { parse("{{ scoped }}{{ end scoped }}",
      blocks: blocks).should be_equal_node_to JOINER(
        TAG(scoped_block.build('scoped'), mode: :normal)
      ) }
    specify { parse("{{ scoped var: 'hello' }}{{ endscoped }}",
      blocks: blocks).should be_equal_node_to JOINER(
        TAG(scoped_block.build('scoped', HASH(PAIR('var', 'hello'))), mode: :normal)
      ) }
    specify { parse("<article>\n{{ each post, in: posts }}\n<h1>{{ post.title }}</h1>\n{{ end each }}\n</article>",
      blocks: blocks).should be_equal_node_to JOINER(
        "<article>\n",
        TAG(each_block.build('each',
          METHOD('post'),
          HASH(PAIR('in', METHOD('posts'))),
          subnodes: [JOINER(
            "\n<h1>",
            TAG(METHOD('title', METHOD('post')), mode: :normal),
            "</h1>\n"
          )]
        ), mode: :normal),
        "\n</article>"
      ) }
    specify { parse("{{! iter = each post, in: posts }}\n<h1>{{ post.title }}</h1>\n{{ end each }}",
      blocks: blocks).should be_equal_node_to JOINER(
        TAG(ASSIGN('iter', each_block.build('each',
          METHOD('post'),
          HASH(PAIR('in', METHOD('posts'))),
          subnodes: [JOINER(
            "\n<h1>",
            TAG(METHOD('title', METHOD('post')), mode: :normal),
            "</h1>\n"
          )]
        )), mode: :silence),
      ) }
    specify { parse("{{ capture = scoped }} hello {{ each post, in: posts }} {{ loop }} {{ end each }}{{ endscoped }}",
      blocks: blocks).should be_equal_node_to JOINER(
        TAG(ASSIGN('capture', scoped_block.build('scoped',
          subnodes: [JOINER(
            ' hello ',
            TAG(each_block.build('each',
              METHOD('post'),
              HASH(PAIR('in', METHOD('posts'))),
              subnodes: [JOINER(
                ' ',
                TAG(METHOD('loop'), mode: :normal),
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
