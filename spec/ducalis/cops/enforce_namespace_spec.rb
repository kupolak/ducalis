# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/enforce_namespace'

RSpec.describe Ducalis::EnforceNamespace do
  subject(:cop) { described_class.new }
  before { allow(cop).to receive(:in_service?).and_return true }

  it '[rule] raises on classes without namespace' do
    inspect_source('class MyService; end')
    expect(cop).to raise_violation(/namespace/)
  end

  it '[rule] better to add a namespace for classes' do
    inspect_source([
                     'module Namespace',
                     '  class MyService',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'raises on modules without namespace' do
    inspect_source('module MyServiceModule; end')
    expect(cop).to raise_violation(/namespace/)
  end

  it 'ignores alone class with namespace' do
    inspect_source('module My; class Service; end; end')
    expect(cop).not_to raise_violation
  end

  it 'ignores multiple classes with namespace' do
    inspect_source('module My; class Service; end; class A; end; end')
    expect(cop).not_to raise_violation
  end

  it 'ignores non-service classes/modules' do
    allow(cop).to receive(:in_service?).and_return false
    inspect_source('module User; end;')
    inspect_source('class User; end;')
    expect(cop).not_to raise_violation
  end
end
