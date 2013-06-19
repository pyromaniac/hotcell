require 'spec_helper'

describe Hotcell::Block do
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

  let(:context) { Hotcell::Context.new }

  describe 'complex parsing and rendering' do
    def parse source
      Hotcell::Template.parse(source)
    end

    let(:if_tag) do
      Class.new(described_class) do
        subcommands :else, :elsif

        def validate!
          names = subcommands.map { |subcommand| subcommand[:name] }
          valid = names.empty? || (
            names.any? && names.last.in?('elsif', 'else') &&
            names[0..-2].uniq.in?(['elsif'], [])
          )
          raise Hotcell::BlockError.new 'Invalid if syntax' unless valid
        end

        def process context, subnodes, condition
          conditions = [[condition]]
          subnodes.each do |subnode|
            if subnode.is_a?(Hash)
              conditions.last[1] = '' if conditions.last[1] == nil
              conditions << (subnode[:name] == 'elsif' ? [subnode[:args].first] : [true])
            else
              conditions.last[1] = subnode
            end
          end
          condition = conditions.detect { |condition| !!condition[0] }
          condition ? condition[1] : nil
        end
      end
    end

    before { Hotcell.stub(:commands) { {} } }
    before { Hotcell.stub(:blocks) { { 'if' => if_tag } } }
    before { Hotcell.stub(:subcommands) { { 'elsif' => if_tag, 'else' => if_tag } } }

    context do
      subject(:template) { parse(<<-SOURCE
        {{ if value == 'hello' }}
          hello
        {{ elsif value == 'world' }}
          world
        {{ else }}
          foobar
        {{ end if }}
        SOURCE
      ) }
      specify { subject.render(value: 'hello').strip.should == 'hello' }
      specify { subject.render(value: 'world').strip.should == 'world' }
      specify { subject.render(value: 'foo').strip.should == 'foobar' }
    end

    context do
      subject(:template) { parse("{{ if value == 'hello' }}{{ elsif value == 'world' }}world{{ end if }}") }
      specify { subject.render(value: 'hello').should == '' }
      specify { subject.render(value: 'world').should == 'world' }
      specify { subject.render(value: 'foo').should == '' }
    end

    context do
      subject(:template) { parse("{{ if value == 'hello' }}{{ else }}world{{ end if }}") }
      specify { subject.render(value: 'hello').should == '' }
      specify { subject.render(value: 'foo').should == 'world' }
    end

    context do
      specify { expect {
        parse("{{ if value == 'hello' }}{{ else }}world{{ elsif }}{{ end if }}").syntax
      }.to raise_error Hotcell::BlockError }
    end
  end

  describe '.subcommands' do
    subject { Class.new(described_class) }

    before { subject.subcommands :elsif, :else }
    its(:subcommands) { should == %w(elsif else) }

    context do
      before { subject.subcommands :when }
      its(:subcommands) { should == %w(elsif else when) }
    end
  end

  describe '#subcommands' do
    specify { described_class.new('if',
      subnodes: [{name: 'elsif'}, JOINER(), {name: 'else'}, JOINER()]).subcommands.should == [
        {name: 'elsif'}, {name: 'else'}] }
  end

  describe '#render_subnodes' do
    specify { described_class.new('if',
      subnodes: [{name: 'elsif', args: ARRAY(3, 5)}, JOINER(42), {name: 'else'}, JOINER(43)]
    ).render_subnodes(context).should == [
      {name: 'elsif', args: [3, 5]}, '42', {name: 'else'}, '43'
    ] }
  end

  describe '#render' do
    let(:block) do
      Class.new(described_class) do
        def process context, subnodes, condition
          "condition #{condition}"
        end
      end
    end

    specify { block.new('if').render(context).should =~ /ArgumentError/ }
    specify { block.new('if', mode: :silence).render(context).should =~ /ArgumentError/ }
    specify { block.new('if', true).render(context).should == "condition true" }
    specify { block.new('if', true, mode: :silence).render(context).should == '' }

    context 'assigning' do
      before { subject.render(context) }

      context do
        subject { block.new('if', assign: 'result') }
        specify { context.key?('result').should be_false }
      end

      context do
        subject { block.new('if', mode: :silence, assign: 'result') }
        specify { context.key?('result').should be_false }
      end

      context do
        subject { block.new('if', true, assign: 'result') }
        specify { context['result'].should == "condition true" }
      end

      context do
        subject { block.new('if', 42, mode: :silence, assign: 'result') }
        specify { context['result'].should == "condition 42" }
      end
    end
  end

  context '#validate!' do
    let(:block) do
      Class.new(described_class) do
        subcommands :else
        def process context, subnodes, condition
          "condition #{condition}"
        end
      end
    end

    context do
      subject { block.new('if', true, subnodes: [TEMPLATE('hello')] ) }
      specify { expect { subject.validate! }.not_to raise_error }
    end

    context do
      subject { block.new('if', true, subnodes: [{ name: 'else' }] ) }
      specify { expect { subject.validate! }.not_to raise_error }
    end

    context do
      subject { block.new('if', true, subnodes: [{ name: 'case' }] ) }
      specify { expect { subject.validate! }.to raise_error }
    end
  end
end
