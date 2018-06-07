require 'spec_helper'
describe 'role_geneious' do
  context 'with default values for all parameters' do
    it { should contain_class('role_geneious') }
  end
end
