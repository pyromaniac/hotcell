# encoding: UTF-8
require 'spec_helper'

describe PufferMarkup::Parser do
  def parse string
    described_class.new(string).parse
  end

  def method_missing method, *args, &block
    PufferMarkup::Node.new method, *args
  end

  specify { parse('{{ }}').should be_equal_node_to TAG() }
  specify { parse('{{ 2 + 2 * 2 }}').should be_equal_node_to TAG(PLUS(2, MULTIPLY(2, 2))) }
  specify { parse('{{ (2 + 2) * 2 }}').should be_equal_node_to TAG(MULTIPLY(2, PLUS(2, 2))) }
  specify { parse('{{ [] }}').should be_equal_node_to TAG(ARRAY()) }
  specify { parse('{{ [ 2 ] }}').should be_equal_node_to TAG(ARRAY(2)) }
  specify { parse('{{ [ 2, 3 ] }}').should be_equal_node_to TAG(ARRAY(2, 3)) }
  specify { parse('{{ [2 + 2, (2 * 2)] }}').should be_equal_node_to TAG(ARRAY(PLUS(2, 2), MULTIPLY(2, 2))) }
  specify { parse('{{ [[2, 3], 42] }}').should be_equal_node_to TAG(ARRAY(ARRAY(2, 3), 42)) }
  specify { parse('{{ {} }}').should be_equal_node_to TAG(HASH()) }
  specify { parse('{{ { hello: \'world\' } }}').should be_equal_node_to(
    TAG(HASH(PAIR(IDENTIFER('hello'), 'world')))
  ) }
  specify { parse('{{ { hello: 3, world: 6 * 7 } }}').should be_equal_node_to(
    TAG(HASH(
      PAIR(IDENTIFER('hello'), 3),
      PAIR(IDENTIFER('world'), MULTIPLY(6, 7))
    ))
  ) }
  specify { parse('{{ hello(2 * 3, {hello: \'fuck\'}) }}').should be_equal_node_to(
    TAG(FUNCTION(
      IDENTIFER('hello'),
      ARGS(
        MULTIPLY(2, 3),
        HASH(PAIR(IDENTIFER('hello'), 'fuck'))
      )
    ))
  ) }
  specify { parse('{{ hello(2 * 3, hello: \'fuck\') }}').should be_equal_node_to(
    TAG(FUNCTION(
      IDENTIFER('hello'),
      ARGS(
        MULTIPLY(2, 3),
        HASH(PAIR(IDENTIFER('hello'), 'fuck'))
      )
    ))
  ) }
end
