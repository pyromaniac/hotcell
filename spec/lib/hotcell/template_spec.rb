require 'spec_helper'

describe Hotcell::Template do
  describe '.parse' do
    before do
      Hotcell.stub(:commands) { { 'include' => Class.new } }
      Hotcell.stub(:blocks) { { 'for' => Class.new } }
    end

    specify { described_class.parse('').should be_a described_class }
    specify { described_class.parse('').options.values.map(&:keys).should == [['include'], ['for']] }
  end

  describe '#syntax' do
    specify { described_class.new('').syntax.should be_a Hotcell::Joiner }
    specify { described_class.new('hello').syntax.should be_a Hotcell::Joiner }
    specify { described_class.new('hello {{ tag }}').syntax.should be_a Hotcell::Joiner }
  end

  describe '#render' do
    context do
      subject { described_class.new('Hello, {{ name }}!') }
      specify { subject.render.should == 'Hello, !' }
      specify { subject.render(variables: { name: 'Friend' }).should == 'Hello, Friend!' }
    end

    context do
      subject { described_class.new('Hello, {{ name * 2 }}!') }
      specify { subject.render.should =~ /Hello.*NoMethodError/ }
      specify { subject.render(variables: { name: 'Friend' }).should == 'Hello, FriendFriend!' }
    end

    context do
      subject { described_class.new('Hello, {{! name }}!') }
      specify { subject.render(variables: { name: 'Friend' }).should == 'Hello, !' }
    end

    context do
      let(:helper) do
        Module.new do
          def name string
            string.capitalize
          end
        end
      end
      subject { described_class.new("Hello, {{ name('pyra') }}!") }
      specify { subject.render(helpers: helper).should == 'Hello, Pyra!' }

      context do
        before { Hotcell.stub(:helpers) { [helper] } }
        specify { subject.render.should == 'Hello, Pyra!' }
        specify { subject.render(helpers: []).should == 'Hello, !' }
      end
    end
  end

  context 'complex tags test' do
    specify { described_class.parse(<<-SOURCE
        {{ for i, in: [1, 2, 3, 4] }}
          {{ if i % 2 == 1 }}
            {{ i }}
          {{ end if }}
        {{ end for }}
      SOURCE
    ).render.gsub(/[\s\n]+/, ' ').strip.should == '1 3' }

    specify { described_class.parse(<<-SOURCE
        {{ for i, in: [1, 2, 3, 4] }}
          {{ for j, in: [4, 3, 2, 1] }}
            {{ i * j }}
          {{ end for }}
        {{ end for }}
      SOURCE
    ).render.gsub(/[\s\n]+/, ' ').strip.should == '4 3 2 1 8 6 4 2 12 9 6 3 16 12 8 4' }
  end
end
