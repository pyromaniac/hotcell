# encoding: UTF-8
require 'spec_helper'

describe PufferMarkup::Parser do
  def parse string
    described_class.new(string).parse
  end

  def method_missing method, *args, &block
    klass = PufferMarkup::Calculator::HANDLERS[method] ?
      PufferMarkup::Calculator : PufferMarkup::Node
    klass = PufferMarkup::Assigner if method == :ASSIGN
    klass = PufferMarkup::Summoner if method == :METHOD
    klass = PufferMarkup::Arrayer if [:ARRAY, :PAIR].include?(method)
    klass = PufferMarkup::Hasher if method == :HASH
    klass = PufferMarkup::Sequencer if [:SEQUENCE, :TAG].include?(method)
    klass = PufferMarkup::Document if method == :DOCUMENT
    klass.new method, *args
  end

  context 'template' do
    specify { parse('').should be_equal_node_to DOCUMENT() }
    specify { parse(' ').should be_equal_node_to DOCUMENT(' ') }
    specify { parse('{{ }}').should be_equal_node_to DOCUMENT(TAG()) }
    specify { parse('hello {{ }}').should be_equal_node_to DOCUMENT('hello ', TAG()) }
    specify { parse('{{ }}hello').should be_equal_node_to DOCUMENT(TAG(), 'hello') }
    specify { parse('hello{{ }} hello').should be_equal_node_to DOCUMENT('hello', TAG(), ' hello') }
    specify { parse('hello {{ hello(\'world\') }} hello').should be_equal_node_to DOCUMENT(
      'hello ', TAG(METHOD(nil, 'hello', 'world')), ' hello'
    ) }
    specify { parse('hello {{ hello(\'world\') }} hello {{! a = 5; }} {}').should be_equal_node_to DOCUMENT(
      'hello ', TAG(METHOD(nil, 'hello', 'world')),
      ' hello ', TAG(ASSIGN('a', 5)), ' {}'
    ) }
    specify { parse('{{ hello(\'world\') }} hello {{! a = 5; }} {}').should be_equal_node_to DOCUMENT(
      TAG(METHOD(nil, 'hello', 'world')),
      ' hello ', TAG(ASSIGN('a', 5)), ' {}'
    ) }
    specify { parse('{{ hello(\'world\') }} hello {{! a = 5; }}').should be_equal_node_to DOCUMENT(
      TAG(METHOD(nil, 'hello', 'world')),
      ' hello ', TAG(ASSIGN('a', 5))
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
    ).should be_equal_node_to DOCUMENT('      ', TAG(
      METHOD(nil, 'hello'),
      42,
      ARRAY(1, 2, 3),
      'hello',
      HASH(),
      SEQUENCE(/regexp/, 43),
      ASSIGN('foo', SEQUENCE(3, 5)),
      ASSIGN('bar', 3),
      5
    ), "\n") }
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
    ).should be_equal_node_to DOCUMENT('      ', TAG(
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
      HASH(PAIR('foo', 'hello'), PAIR('bar', 'world'))
    ), "\n") }
  end

  context 'expressions' do
    specify { parse('{{ 2 + hello }}').should be_equal_node_to DOCUMENT(TAG(PLUS(2, METHOD(nil, 'hello')))) }
    specify { parse('{{ --2 }}').should be_equal_node_to DOCUMENT(TAG(2)) }
    specify { parse('{{ --hello }}').should be_equal_node_to DOCUMENT(TAG(UMINUS(UMINUS(METHOD(nil, 'hello'))))) }
    specify { parse('{{ \'hello\' + \'world\' }}').should be_equal_node_to DOCUMENT(TAG('helloworld')) }
    specify { parse('{{ 2 - hello }}').should be_equal_node_to DOCUMENT(TAG(MINUS(2, METHOD(nil, 'hello')))) }
    specify { parse('{{ 2 * hello }}').should be_equal_node_to DOCUMENT(TAG(MULTIPLY(2, METHOD(nil, 'hello')))) }
    specify { parse('{{ 2 / hello }}').should be_equal_node_to DOCUMENT(TAG(DIVIDE(2, METHOD(nil, 'hello')))) }
    specify { parse('{{ 2 % hello }}').should be_equal_node_to DOCUMENT(TAG(MODULO(2, METHOD(nil, 'hello')))) }
    specify { parse('{{ 2 ** hello }}').should be_equal_node_to DOCUMENT(TAG(POWER(2, METHOD(nil, 'hello')))) }
    specify { parse('{{ -hello }}').should be_equal_node_to DOCUMENT(TAG(UMINUS(METHOD(nil, 'hello')))) }
    specify { parse('{{ +hello }}').should be_equal_node_to DOCUMENT(TAG(UPLUS(METHOD(nil, 'hello')))) }
    specify { parse('{{ -2 }}').should be_equal_node_to DOCUMENT(TAG(-2)) }
    specify { parse('{{ +2 }}').should be_equal_node_to DOCUMENT(TAG(2)) }
    specify { parse('{{ 2 + lol * 2 }}').should be_equal_node_to DOCUMENT(TAG(PLUS(2, MULTIPLY(METHOD(nil, 'lol'), 2)))) }
    specify { parse('{{ 2 + lol - 2 }}').should be_equal_node_to DOCUMENT(TAG(MINUS(PLUS(2, METHOD(nil, 'lol')), 2))) }
    specify { parse('{{ 2 ** foo * 2 }}').should be_equal_node_to DOCUMENT(TAG(MULTIPLY(POWER(2, METHOD(nil, 'foo')), 2))) }
    specify { parse('{{ 1 ** foo ** 3 }}').should be_equal_node_to DOCUMENT(TAG(POWER(1, POWER(METHOD(nil, 'foo'), 3)))) }
    specify { parse('{{ (2 + foo) * 2 }}').should be_equal_node_to DOCUMENT(TAG(MULTIPLY(PLUS(2, METHOD(nil, 'foo')), 2))) }
    specify { parse('{{ (nil) }}').should be_equal_node_to DOCUMENT(TAG(nil)) }
    specify { parse('{{ (3) }}').should be_equal_node_to DOCUMENT(TAG(3)) }
    specify { parse('{{ (\'hello\') }}').should be_equal_node_to DOCUMENT(TAG('hello')) }
    specify { parse('{{ () }}').should be_equal_node_to DOCUMENT(TAG(nil)) }

    specify { parse('{{ bar > 2 }}').should be_equal_node_to DOCUMENT(TAG(GT(METHOD(nil, 'bar'), 2))) }
    specify { parse('{{ 2 < bar }}').should be_equal_node_to DOCUMENT(TAG(LT(2, METHOD(nil, 'bar')))) }
    specify { parse('{{ 2 >= tru }}').should be_equal_node_to DOCUMENT(TAG(GTE(2, METHOD(nil, 'tru')))) }
    specify { parse('{{ some <= 2 }}').should be_equal_node_to DOCUMENT(TAG(LTE(METHOD(nil, 'some'), 2))) }
    specify { parse('{{ 2 && false }}').should be_equal_node_to DOCUMENT(TAG(false)) }
    specify { parse('{{ null || 2 }}').should be_equal_node_to DOCUMENT(TAG(2)) }
    specify { parse('{{ 2 > bar < 2 }}').should be_equal_node_to DOCUMENT(TAG(LT(GT(2, METHOD(nil, 'bar')), 2))) }
    specify { parse('{{ 2 || bar && 2 }}').should be_equal_node_to DOCUMENT(TAG(OR(2, AND(METHOD(nil, 'bar'), 2)))) }
    specify { parse('{{ 2 && foo || 2 }}').should be_equal_node_to DOCUMENT(TAG(OR(AND(2, METHOD(nil, 'foo')), 2))) }
    specify { parse('{{ !2 && moo }}').should be_equal_node_to DOCUMENT(TAG(AND(false, METHOD(nil, 'moo')))) }
    specify { parse('{{ !(2 && moo) }}').should be_equal_node_to DOCUMENT(TAG(NOT(AND(2, METHOD(nil, 'moo'))))) }

    specify { parse('{{ hello = bzz + 2 }}').should be_equal_node_to DOCUMENT(TAG(ASSIGN('hello', PLUS(METHOD(nil, 'bzz'), 2)))) }
    specify { parse('{{ hello = 2 ** bar }}').should be_equal_node_to DOCUMENT(TAG(ASSIGN('hello', POWER(2, METHOD(nil, 'bar'))))) }
    specify { parse('{{ hello = 2 == 2 }}').should be_equal_node_to DOCUMENT(TAG(ASSIGN('hello', true))) }
    specify { parse('{{ hello = 2 && var }}').should be_equal_node_to DOCUMENT(TAG(ASSIGN('hello', AND(2, METHOD(nil, 'var'))))) }
    specify { parse('{{ hello = world() }}').should be_equal_node_to DOCUMENT(TAG(ASSIGN('hello', METHOD(nil, 'world')))) }
    specify { parse('{{ !hello = 2 >= 2 }}').should be_equal_node_to DOCUMENT(TAG(NOT(ASSIGN('hello', true)))) }

    specify { parse('{{ !foo ** 2 + 3 }}').should be_equal_node_to DOCUMENT(TAG(PLUS(POWER(NOT(METHOD(nil, 'foo')), 2), 3))) }
    specify { parse('{{ -bla ** 2 }}').should be_equal_node_to DOCUMENT(TAG(UMINUS(POWER(METHOD(nil, 'bla'), 2)))) }
    specify { parse('{{ -2 % bla }}').should be_equal_node_to DOCUMENT(TAG(MODULO(-2, METHOD(nil, 'bla')))) }
    specify { parse('{{ -hello ** 2 }}').should be_equal_node_to DOCUMENT(TAG(UMINUS(POWER(METHOD(nil, 'hello'), 2)))) }
    specify { parse('{{ -hello * 2 }}').should be_equal_node_to DOCUMENT(TAG(MULTIPLY(UMINUS(METHOD(nil, 'hello')), 2))) }
    specify { parse('{{ haha + 2 == 2 * 2 }}').should be_equal_node_to DOCUMENT(TAG(EQUAL(PLUS(METHOD(nil, 'haha'), 2), 4))) }
    specify { parse('{{ 2 * foo != 2 && bar }}').should be_equal_node_to DOCUMENT(TAG(AND(INEQUAL(MULTIPLY(2, METHOD(nil, 'foo')), 2), METHOD(nil, 'bar')))) }

    context 'method call' do
      specify { parse('{{ foo.bar.baz }}').should be_equal_node_to DOCUMENT(TAG(
        METHOD(METHOD(METHOD(nil, 'foo'), 'bar'), 'baz')
      )) }
      specify { parse('{{ foo(\'hello\').bar[2].baz(-42) }}').should be_equal_node_to DOCUMENT(TAG(
        METHOD(
          METHOD(
            METHOD(
              METHOD(
                nil, 'foo', 'hello'
              ), 'bar'
            ), '[]', 2
          ), 'baz', -42
        )
      )) }
    end
  end

  context 'arrays' do
    specify { parse('{{ [] }}').should be_equal_node_to DOCUMENT(TAG(ARRAY())) }
    specify { parse('{{ [ 2 ] }}').should be_equal_node_to DOCUMENT(TAG(ARRAY(2))) }
    specify { parse('{{ [ 2, 3 ] }}').should be_equal_node_to DOCUMENT(TAG(ARRAY(2, 3))) }
    specify { parse('{{ [2, 3][42] }}').should be_equal_node_to DOCUMENT(TAG(METHOD(ARRAY(2, 3), '[]', 42))) }
    specify { parse('{{ [2 + foo, (2 * bar)] }}').should be_equal_node_to DOCUMENT(TAG(ARRAY(PLUS(2, METHOD(nil, 'foo')), MULTIPLY(2, METHOD(nil, 'bar'))))) }
    specify { parse('{{ [[2, 3], 42] }}').should be_equal_node_to DOCUMENT(TAG(ARRAY(ARRAY(2, 3), 42))) }
  end

  context 'hashes' do
    specify { parse('{{ {} }}').should be_equal_node_to DOCUMENT(TAG(HASH())) }
    specify { parse('{{ { hello: \'world\' } }}').should be_equal_node_to(
      DOCUMENT(TAG(HASH(PAIR('hello', 'world'))))
    ) }
    specify { parse('{{ {hello: \'world\'}[\'hello\'] }}').should be_equal_node_to(
      DOCUMENT(TAG(METHOD(HASH(PAIR('hello', 'world')), '[]', 'hello')))
    ) }
    specify { parse('{{ { hello: 3, world: 6 * foo } }}').should be_equal_node_to(
      DOCUMENT(TAG(HASH(
        PAIR('hello', 3),
        PAIR('world', MULTIPLY(6, METHOD(nil, 'foo')))
      )))
    ) }
  end

  context '[]' do
    specify { parse('{{ hello[3] }}').should be_equal_node_to DOCUMENT(TAG(METHOD(METHOD(nil, 'hello'), '[]', 3))) }
    specify { parse('{{ \'boom\'[3] }}').should be_equal_node_to DOCUMENT(TAG(METHOD('boom', '[]', 3))) }
    specify { parse('{{ 7[3] }}').should be_equal_node_to DOCUMENT(TAG(METHOD(7, '[]', 3))) }
    specify { parse('{{ 3 + 5[7] }}').should be_equal_node_to DOCUMENT(TAG(PLUS(3, METHOD(5, '[]', 7)))) }
    specify { parse('{{ (3 + 5)[7] }}').should be_equal_node_to DOCUMENT(TAG(METHOD(8, '[]', 7))) }
  end

  context 'function arguments' do
    specify { parse('{{ hello() }}').should be_equal_node_to DOCUMENT(TAG(METHOD(nil, 'hello'))) }
    specify { parse('{{ hello(2 * foo) }}').should be_equal_node_to(
      DOCUMENT(TAG(METHOD(nil, 'hello', MULTIPLY(2, METHOD(nil, 'foo')))))
    ) }
    specify { parse('{{ hello([2 * car]) }}').should be_equal_node_to(
      DOCUMENT(TAG(METHOD(nil, 'hello', ARRAY(MULTIPLY(2, METHOD(nil, 'car'))))))
    ) }
    specify { parse('{{ hello({hello: \'world\'}) }}').should be_equal_node_to(
      DOCUMENT(TAG(METHOD(nil, 'hello', HASH(PAIR('hello', 'world')))))
    ) }
    specify { parse('{{ hello(hello: \'world\') }}').should be_equal_node_to(
      DOCUMENT(TAG(METHOD(nil, 'hello', HASH(PAIR('hello', 'world')))))
    ) }
    specify { parse('{{ hello(2 * foo, \'bla\', {hello: \'world\'}) }}').should be_equal_node_to(
      DOCUMENT(TAG(METHOD(nil, 'hello',
        MULTIPLY(2, METHOD(nil, 'foo')),
        'bla',
        HASH(PAIR('hello', 'world'))
      )))
    ) }
    specify { parse('{{ hello(moo * 3, \'bla\', hello: \'world\') }}').should be_equal_node_to(
      DOCUMENT(TAG(METHOD(nil, 'hello',
        MULTIPLY(METHOD(nil, 'moo'), 3),
        'bla',
        HASH(PAIR('hello', 'world'))
      )))
    ) }
  end

  context 'sequences' do
    specify { parse('{{ 42; }}').should be_equal_node_to DOCUMENT(TAG(42)) }
    specify { parse('{{ (42) }}').should be_equal_node_to DOCUMENT(TAG(42)) }
    specify { parse('{{ ((42)) }}').should be_equal_node_to DOCUMENT(TAG(42)) }
    specify { parse('{{ ;;;; }}').should be_equal_node_to DOCUMENT(TAG()) }
    specify { parse('{{ ;;;;;;; 42 }}').should be_equal_node_to DOCUMENT(TAG(42)) }
    specify { parse('{{ ;;;111;;;; 42 }}').should be_equal_node_to DOCUMENT(TAG(111, 42)) }
    specify { parse('{{ 42 ;;;;;; }}').should be_equal_node_to DOCUMENT(TAG(42)) }
    specify { parse('{{ 42 ;;;;;;1 }}').should be_equal_node_to DOCUMENT(TAG(42, 1)) }
    specify { parse('{{ 42; 43 }}').should be_equal_node_to DOCUMENT(TAG(42, 43)) }
    specify { parse('{{ ; 42; 43 }}').should be_equal_node_to DOCUMENT(TAG(42, 43)) }
    specify { parse('{{ 42; 43; 44 }}').should be_equal_node_to DOCUMENT(TAG(42, 43, 44)) }
    specify { parse('{{ 42; \'hello\'; 44; }}').should be_equal_node_to DOCUMENT(TAG(42, 'hello', 44)) }
    specify { parse('{{ (42; \'hello\'); 44; }}').should be_equal_node_to DOCUMENT(TAG(SEQUENCE(42, 'hello'), 44)) }
    specify { parse('{{ 42; (\'hello\'; 44;) }}').should be_equal_node_to DOCUMENT(TAG(42, SEQUENCE('hello', 44))) }
    specify { parse('{{ hello(42, (43; 44), 45) }}').should be_equal_node_to DOCUMENT(TAG(METHOD(nil, 'hello', 42, SEQUENCE(43, 44), 45))) }
    specify { parse('{{ hello(42, ((43; 44)), 45) }}').should be_equal_node_to DOCUMENT(TAG(METHOD(nil, 'hello', 42, SEQUENCE(43, 44), 45))) }
    specify { parse('{{ hello((42)) }}').should be_equal_node_to DOCUMENT(TAG(METHOD(nil, 'hello', 42))) }
  end
end
