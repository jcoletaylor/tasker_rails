# typed: false
# frozen_string_literal: true

RSpec.describe DummyRustTaskHandler do
  it 'has a version number' do
    expect(DummyRustTaskHandler::VERSION).not_to be nil
  end

  it 'can run the rust handler' do
    inputs = { one: :two }
    results = DummyRustTaskHandler::Handler.handle(inputs)
    expect(results).to eq({ 'dummy' => true })
  end
end
