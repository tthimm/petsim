ruby = %x(ruby --version)
unless %r(1\.9\..).match(ruby) then
  raise "Error: ruby version 1.9.x required"
end

require 'rubygems'
require 'gosu'
require "#{File.dirname(__FILE__)}/../lib/dependency/dependency.rb"

DEBUG = true

loader = Dependency.new
loader.add_rule("top")
loader.add_dir("lib")
loader.add_dir("app/logic")
loader.add_dir("app/draw")
loader.ignore("lib/dependency/dependency.rb")
loader.process_directories
include Gosu
