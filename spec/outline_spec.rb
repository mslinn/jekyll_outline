require 'jekyll'
require_relative '../lib/jekyll_outline'

RSpec.describe(Outline) do
  include Jekyll

  it 'is created properly' do
    pending 'This is just a placeholder'
    run_tag = RunTag.new('run', 'echo asdf')
    output = run_tag.render(context)
    expect(output).to eq('asdf')
  end
end
