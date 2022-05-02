# frozen_string_literal: true

require "jekyll"
require_relative "../lib/jekyll_outline"

RSpec.describe(Jekyll) do
  include Jekyll

  it "is created properly" do
    # run_tag = RunTag.new("run", "echo asdf")
    # output = run_tag.render(context)
    # expect(output).to eq("asdf")
  end
end
