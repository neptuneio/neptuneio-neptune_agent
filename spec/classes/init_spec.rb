require 'spec_helper'
describe 'neptune_agent' do
  context 'with default values for all parameters' do
    it { should contain_class('neptune_agent') }
  end
end
