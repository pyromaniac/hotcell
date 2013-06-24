# coding: UTF-8

require 'spec_helper'

describe Hotcell::Source do
  subject(:source) { described_class.new('hello', 'file/path') }

  describe '.wrap' do
    specify { described_class.wrap('hello').should be_a described_class }
    specify { described_class.wrap('hello').source.should == 'hello' }
    specify { described_class.wrap(source).should === source }
  end

  describe '#initialize' do
    its(:source) { should == 'hello' }
    its(:file) { should == 'file/path' }
    specify { described_class.new('hello').source.should == 'hello' }
    specify { described_class.new('hello').file.should be_nil }
  end

  describe '#data' do
    its(:data) { should == [104, 101, 108, 108, 111] }
  end

  describe '#info' do
    def info source, position
      described_class.new(source, 'file/path').info(position)
    end

    specify { info('hello', 0).should == { line: 1, column: 1 } }
    specify { info('hello', 100).should == { line: 1, column: 5 } }
    specify { info('hello', 2).should == { line: 1, column: 3 } }
    specify { info('привет', 0).should == { line: 1, column: 1 } }
    specify { info('привет', 4).should == { line: 1, column: 3 } }
    specify { info('привет', 100).should == { line: 1, column: 6 } }
    specify { info("привет\nhello", 0).should == { line: 1, column: 1 } }
    specify { info("привет\nhello", 100).should == { line: 2, column: 5 } }
    specify { info("привет\nhello", 15).should == { line: 2, column: 3 } }
    specify { info("привет\nhello", 7).should == { line: 1, column: 4 } }
  end
end
