require 'rubygems'
require 'bundler'
Bundler.require

require './submit'

Rack::Handler::Thin.run Sinatra::Application, :Port => (ENV['PORT']||9400).to_i
