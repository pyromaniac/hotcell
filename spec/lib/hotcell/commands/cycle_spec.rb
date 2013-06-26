require 'spec_helper'

describe Hotcell::Commands::Cycle do
  def parse source
    Hotcell::Template.parse(source)
  end

  describe '#normalize_arguments' do
    subject { described_class.new 'cycle' }
    specify { subject.normalize_arguments([42]).should == [[42], subject.object_id.to_s] }
    specify { subject.normalize_arguments([42, 43, 44]).should == [[42, 43, 44], subject.object_id.to_s] }
    specify { subject.normalize_arguments(['hello' => 42]).should == [[42], 'hello'] }
    specify { subject.normalize_arguments(['hello' => [42, 43, 44]]).should == [[42, 43, 44], 'hello'] }
    specify { subject.normalize_arguments([42, { 'group' => 'hello' }]).should == [[42], 'hello'] }
    specify { subject.normalize_arguments([42, 43, { 'group' => 'hello' }]).should == [[42, 43], 'hello'] }
  end

  describe '#render' do
    specify { parse(
      "{{ cycle 'one', 'two', 'three' }} {{ cycle 'one', 'two', 'three' }}"
    ).render.should == 'one one' }
    specify { parse(
      "{{ cycle count: ['one', 'two', 'three'] }} {{ cycle 'one', 'two', 'three', group: 'count' }}"
    ).render.should == 'one two' }
    specify { parse(
      "{{ for i, in: [1, 2, 3], loop: true }}{{ i }} {{ cycle ['one', 'two', 'three'] }}{{ unless loop.last? }}, {{ end unless }}{{ end for }}"
    ).render.should == '1 one, 2 two, 3 three' }
  end
end
