# frozen_string_literal: true

require_relative "lib/jekyll_outline/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  github = "https://github.com/mslinn/jekyll_outline"

  spec.authors = ["Mike Slinn"]
  spec.bindir = "exe"
  spec.description = <<~END_OF_DESC
    Jekyll tag plugin that creates a clickable table of contents.
  END_OF_DESC
  spec.email = ["mslinn@mslinn.com"]
  spec.files = Dir[".rubocop.yml", "LICENSE.*", "Rakefile", "{lib,spec}/**/*", "*.gemspec", "*.md"]
  spec.homepage = "https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html#run"
  spec.license = "MIT"
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri"   => "#{github}/issues",
    "changelog_uri"     => "#{github}/CHANGELOG.md",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => github,
  }
  spec.name = "jekyll_outline"
  spec.post_install_message = <<~END_MESSAGE

    Thanks for installing #{spec.name}!

  END_MESSAGE
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.6.0"
  spec.summary = "Jekyll tag plugin that creates a clickable table of contents."
  spec.test_files = spec.files.grep(%r!^(test|spec|features)/!)
  spec.version = JekyllOutlineVersion::VERSION

  spec.add_dependency "jekyll", ">= 3.5.0"
  spec.add_dependency "jekyll_draft"
  spec.add_dependency "jekyll_plugin_logger"
end
# rubocop:enable Metrics/BlockLength
