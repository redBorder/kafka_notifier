# -*- encoding: utf-8 -*-
require File.expand_path('../lib/kafka_notifier/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'kafka_notifier'
  s.version = ::KafkaNotifier::VERSION
  s.authors = ["Carlos Rodriguez"]
  s.email = 'crodriguez@redborder.net'
  s.description = 'Sends a message to kafka whenever an active record instance is created, updated and/or removed.'
  s.files = Dir.glob('lib/**/*') + ['LICENSE', 'README.md']
  s.homepage = 'http://github.com/redborder/kafka_notifier'
  s.require_paths = ['lib']
  s.summary = 'Sends a message to kafka whenever an active record instance is created, updated and/or removed.'
  s.license = 'AGPL'
  
  s.add_runtime_dependency 'activerecord'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'poseidon'

  s.add_development_dependency 'rspec'
end
