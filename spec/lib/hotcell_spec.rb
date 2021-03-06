require 'spec_helper'

describe Hotcell do
  it { should respond_to :commands }
  it { should respond_to :blocks }
  it { should respond_to :helpers }
  it { should respond_to :register_command }
  it { should respond_to :register_helpers }
  it { should respond_to :escape_tags }
end
