require 'jekyll'
require_relative '../lib/jekyll_outline'

RSpec.describe(Outline) do
  include Jekyll

  it 'never works first time', skip: 'Just a placeholder' do
    expect(true).to be_truthy
  end
end
