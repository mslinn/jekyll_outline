require_relative 'outline_js'
require_relative 'outline_tag'

module Outline
  include OutlineTag
  include OutlineJsTag
end
