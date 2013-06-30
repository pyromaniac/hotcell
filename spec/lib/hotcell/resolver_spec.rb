require 'spec_helper'

describe Hotcell::Resolver do
  specify { expect { subject.template 'any/path' }.to raise_error NotImplementedError }

  describe '#template' do
    let(:dummy) do
      Class.new(described_class) do
        def resolve path, context = nil
          path
        end
      end
    end
    subject { dummy.new.template('template/source') }

    it { should be_a Hotcell::Template }
    its('source.source') { should == 'template/source' }
  end
end

describe Hotcell::FileSystemResolver do
  subject(:resolver) { described_class.new(data_path('templates')) }

  describe '#resolve' do
    specify { subject.resolve('simple').should == 'Hello, {{ name }}' }
    specify { expect { subject.resolve('unexisting') }.to raise_error Errno::ENOENT }
  end
end
